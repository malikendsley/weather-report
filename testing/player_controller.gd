extends CharacterBody2D

@onready var state_label: Label = $CurStateLabel

const SPEED = 300.0 # px/s
const ACCELERATION = 3000.0 # px/s^2
const FRICTION = 2000.0 # px/s^2
const MAX_FALL_SPEED = 1000.0 # px/s
const GRAVITY = 2000.0 # px/s^2
const JUMP_VELOCITY = -400.0	


enum PlayerState {
	idle, # Standing still.
	walk, # Walking.
	run, # Running.
	jumping, # Ascending.
	fall, # Descending.
	slide, # During a low-dash
}
enum Grenades {
	stasis,
	blast,
}

# TODO: Extract to a persistent state tracker for the player
var has_dash_slide := false
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

var air_dashes_left := 0

var state_names := {
	PlayerState.idle: "Free",
	PlayerState.walk: "Walk",
	PlayerState.run: "Run",
	PlayerState.jumping: "Jumping",
	PlayerState.fall: "Fall",
	PlayerState.slide: "Slide"
}
var current_state := PlayerState.idle:
	set(new_state):
		state_label.text = state_names[new_state]
		current_state = new_state

var directional_input := Vector2.ZERO





func _ready() -> void:
	state_label.text = state_names[current_state]

func _process(_delta: float) -> void:
	directional_input.x = Input.get_axis("move_left", "move_right")
	directional_input.y = Input.get_axis("move_up", "move_down")

func _physics_process(delta: float) -> void:

	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle movement
	match current_state:
		PlayerState.idle:
			
			velocity.x = move_toward(velocity.x, directional_input.x * SPEED, ACCELERATION * delta)

			if InputBuffer.consume("jump"):
				print("Jumping")
				velocity.y = JUMP_VELOCITY
				current_state = PlayerState.jumping
			if directional_input.x != 0:
				current_state = PlayerState.walk
			elif not is_on_floor():
				current_state = PlayerState.fall

		PlayerState.walk:
			velocity.x = move_toward(velocity.x, directional_input.x * SPEED, ACCELERATION * delta)

			if directional_input.x == 0:
				current_state = PlayerState.idle
			elif not is_on_floor():
				current_state = PlayerState.fall

		PlayerState.fall:
			if is_on_floor():
				current_state = PlayerState.idle

		PlayerState.jumping: 
			if is_on_floor():
				current_state = PlayerState.idle
			elif velocity.y < 0:
				current_state = PlayerState.jumping
			else:
				current_state = PlayerState.fall
		_:
			pass # Other states remain unchanged for now.

	# Apply movement
	move_and_slide()
