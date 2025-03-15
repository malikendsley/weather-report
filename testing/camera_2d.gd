extends Camera2D

# The camera targets a point halfway between the player and the mouse cursor
# It at a speed proportional to how far the camera is from the target, with a deadzone below which the camera won't move
# The camera will not exceed the room's bounds (TODO)
@export var player: CharacterBody2D
@export var target_text: Label

## The camera will not prevent the player from being closer than this distance to the edge of the screen, as a fraction of viewport size.
@export var deadzone: float = 0.9
## Will bias the camera towards the player or the mouse cursor. 1 is towards the mouse.
@export var use_room_bounds: bool = false

@export var room_top_left: Vector2
@export var room_bottom_right: Vector2
@onready var camera_target: Sprite2D = %CrosshairDebug

@export var camera_max_x: int = 256
@export var camera_max_y: int = 128

func _process(_delta: float) -> void:
	# mouse position, normalized over 0-1
	var gmp := get_viewport().get_mouse_position()
	var mouse_position_unnormalized: Vector2 = (get_viewport().get_mouse_position() / (get_viewport().size / 2.0)) - Vector2(1, 1)
	var mouse_position := mouse_position_unnormalized.clamp(-Vector2.ONE, Vector2.ONE)
	target_text.text = str(gmp)

	global_position = player.global_position + (mouse_position) * Vector2(camera_max_x, camera_max_y)
	

	# Deadzone takes priority over camera target.
	var distanceX: float = deadzone * get_viewport().size.x / 2
	var distanceY: float = deadzone * get_viewport().size.y / 2
	clamp_pos_to_rect_distance_from_point(player.global_position, Vector2(distanceX, distanceY))

	# Room bounds take priority over deadzone and camera target.
	if use_room_bounds:
		clamp_pos_to_room_bounds()

# TODO: These functions spiritually do the same thing and can probably be combined
func clamp_pos_to_rect_distance_from_point(point: Vector2, distances: Vector2) -> void:
	global_position.x = clamp(global_position.x, point.x - distances.x, point.x + distances.x)
	global_position.y = clamp(global_position.y, point.y - distances.y, point.y + distances.y)

func clamp_pos_to_room_bounds() -> void:
	# because the camera position is its center, we need to "shrink" the room bounds by half the viewport size
	var temp_top_left: Vector2 = room_top_left + get_viewport().size / 2.0
	var temp_bottom_right: Vector2 = room_bottom_right - get_viewport().size / 2.0

	global_position.x = clamp(global_position.x, temp_top_left.x, temp_bottom_right.x)
	global_position.y = clamp(global_position.y, temp_top_left.y, temp_bottom_right.y)