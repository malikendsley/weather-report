extends Camera2D

@export var player: CharacterBody2D
@export var target_text: Label

@export var deadzone: float = 0.9
@export var use_room_bounds: bool = false
@export var room_top_left: Vector2
@export var room_bottom_right: Vector2

@export var camera_max_x: int = 256
@export var camera_max_y: int = 128

@export var snap_enabled := true
@export var pixel_size := 1.0

# We’ll store the camera’s transform as our “snap space.”
var _snap_space : Transform2D

func _ready() -> void:
    # Initialize our snap space
    _snap_space = global_transform

func _process(_delta: float) -> void:
    # 1) Calculate the desired camera position as you already do.
    var gmp = get_viewport().get_mouse_position()
    var mouse_position_unnormalized = (gmp / (get_viewport().size / 2.0)) - Vector2(1, 1)
    var mouse_position = mouse_position_unnormalized.clamp(-Vector2.ONE, Vector2.ONE)
    
    global_position = player.global_position + mouse_position * Vector2(camera_max_x, camera_max_y)
    
    # 2) Apply your deadzone clamp.
    var distance_x: float = deadzone * get_viewport().size.x / 2
    var distance_y: float = deadzone * get_viewport().size.y / 2
    clamp_pos_to_rect_distance_from_point(player.global_position, Vector2(distance_x, distance_y))
    
    # 3) Apply your room‐bounds clamp.
    if use_room_bounds:
        clamp_pos_to_room_bounds()
    
    # 4) Pixel‐snap as a final step. 
    #    Update snap space if you need rotation snapping. If your camera doesn’t rotate, 
    #    you can skip reassigning _snap_space each frame.
    _snap_space = global_transform
    
    if snap_enabled:
        # Convert our final global_position into the “snap space.”
        var snap_space_pos = _snap_space.affine_inverse().basis_xform(global_position)
        # Snap to the pixel grid.
        var snapped_space_pos = snap_space_pos.snapped(Vector2.ONE * pixel_size)
        var snap_error = snapped_space_pos - snap_space_pos
        
        # Convert that snapping difference back to world space,
        # and store it in the camera’s offset.
        var world_error = _snap_space.basis_xform(snap_error)
        offset = world_error
    else:
        offset = Vector2.ZERO


func clamp_pos_to_rect_distance_from_point(point: Vector2, distances: Vector2) -> void:
    global_position.x = clamp(global_position.x, point.x - distances.x, point.x + distances.x)
    global_position.y = clamp(global_position.y, point.y - distances.y, point.y + distances.y)

func clamp_pos_to_room_bounds() -> void:
    var temp_top_left: Vector2 = room_top_left + get_viewport().size / 2.0
    var temp_bottom_right: Vector2 = room_bottom_right - get_viewport().size / 2.0
    
    global_position.x = clamp(global_position.x, temp_top_left.x, temp_bottom_right.x)
    global_position.y = clamp(global_position.y, temp_top_left.y, temp_bottom_right.y)
