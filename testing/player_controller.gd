extends CharacterBody2D

@export var state_label: Label
@export var velocity_label: Label
@export var can_dash_text: Label

const SPEED = 300.0 # px/s
const DAMP_SPEED = 300.0 # px/s
const DAMP_AIR_SPEED = 400.0 # px/s
const ACCELERATION = 3000.0 # px/s^2
const MAX_FALL_SPEED = 1000.0 # px/s
const GRAVITY = 2000.0 # px/s^2
const JUMP_VELOCITY = -800.0	
const DAMPENING_FACTOR = 5

enum PlayerState {
	idle, # Standing still.
	walk, # Walking.
	jumping, # Ascending.
	fall, # Descending.
	dash, # During a low-dash
	airdash,
}
enum Grenades {
	stasis,
	blast,
}

# TODO: Extract to a persistent state tracker for the player
# TODO: Integrate with the weapon controller
var has_dash_dash := false
var has_jump_cancel := false
var has_alt_fire := false
var has_warp_core := false
var has_stasis_grenade := false
var has_blast_grenade := false

var grenade_timer := 0.0
var current_grenade := Grenades.stasis
var grenade_deployed := false

var warp_core_timer := 0.0
var warp_core_deployed:= false

var state_names := {
	PlayerState.idle: "Free",
	PlayerState.walk: "Walk",
	PlayerState.jumping: "Jumping",
	PlayerState.fall: "Fall",
	PlayerState.dash: "dash",
	PlayerState.airdash: "Airdash"
}
var current_state := PlayerState.idle:
	set(new_state):
		state_label.text = state_names[new_state]
		current_state = new_state

var directional_input := Vector2.ZERO

var min_ground_dash_duration := 0.5
var min_air_dash_duration := 0.5
var dash_time_left := min_ground_dash_duration
var dash_available := true:
	set(new_state):
		can_dash_text.text = str(new_state)
		dash_available = new_state


func _ready() -> void:
	state_label.text = state_names[current_state]

func _process(_delta: float) -> void:
	directional_input.x = Input.get_axis("move_left", "move_right")
	directional_input.y = Input.get_axis("move_up", "move_down")

func _physics_process(delta: float) -> void:

	# Apply gravity
	if not is_on_floor() and current_state != PlayerState.airdash:
		velocity.y += GRAVITY * delta

	# Handle movement, with dampening (likely to only be used for sliding)
	if abs(velocity.x) > SPEED * 1.03:
		var overspeed : float = abs(velocity.x) - (DAMP_SPEED if is_on_floor() else abs(velocity.x) - DAMP_AIR_SPEED)
		var damp : float = overspeed * (1.0 - exp(-DAMPENING_FACTOR * delta))
		damp = max(damp, 30)
		velocity.x -= damp * sign(velocity.x)
	else:
		velocity.x = move_toward(velocity.x, directional_input.x * SPEED, ACCELERATION * delta)

	match current_state:
		PlayerState.idle:
			if InputBuffer.consume("jump"):
				enter_state(PlayerState.jumping)
			elif directional_input.x != 0:
				enter_state(PlayerState.walk)
			elif not is_on_floor():
				current_state = PlayerState.fall

		PlayerState.walk:
			if InputBuffer.consume("dash"):
				enter_state(PlayerState.dash)
			elif InputBuffer.consume("jump"):
				enter_state(PlayerState.jumping)
			elif directional_input.x == 0:
				enter_state(PlayerState.idle)
			elif not is_on_floor():
				current_state = PlayerState.fall

		PlayerState.fall:
			if dash_available and directional_input.x != 0 and  InputBuffer.consume("dash"):
				enter_state(PlayerState.airdash)
			elif is_on_floor():
				enter_state(PlayerState.idle)

		PlayerState.jumping: 
			if dash_available and directional_input.x != 0 and InputBuffer.consume("dash"):
				enter_state(PlayerState.airdash)
			elif is_on_floor():
				enter_state(PlayerState.idle)
			elif velocity.y > 0:
				current_state = PlayerState.fall

		# note y velocity is frozen during airdash
		PlayerState.airdash:
			dash_time_left -= delta
			if dash_time_left <= 0:
				enter_state(PlayerState.fall)
				dash_time_left = 0

		# We will always enter this state with a horizontal velocity higher than the player's running speed and trigger dampening.
		PlayerState.dash:
			dash_time_left -= delta
			if dash_time_left <= 0 or abs(velocity.x) < SPEED:
				enter_state(PlayerState.idle)
				dash_time_left = 0
			elif InputBuffer.consume("jump"):
				enter_state(PlayerState.jumping)
				dash_time_left = 0
		_:
			pass # Other states remain unchanged for now.

	# Apply movement
	move_and_slide()
	velocity_label.text = str(velocity)



func enter_state(state: PlayerState) -> void:
	match state:
		PlayerState.idle:
			dash_available = true
		PlayerState.walk:
			dash_available = true
		PlayerState.jumping:
			dash_available = true
			# TODO: I do not like this.
			if current_state == PlayerState.dash:
				velocity.y = JUMP_VELOCITY * sqrt(2)
			else:
				velocity.y = JUMP_VELOCITY
		PlayerState.fall:
			pass
		PlayerState.dash:
			dash_available = false
			velocity.x = directional_input.x * SPEED * 4
			dash_time_left = min_ground_dash_duration
		PlayerState.airdash:
			dash_available = false
			velocity.x = directional_input.x * SPEED * 4
			dash_time_left = min_air_dash_duration
			velocity.y = 0
		_:
			pass
		
	current_state = state