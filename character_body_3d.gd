extends CharacterBody3D


@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0
@export var jump_impulse := 12.0

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 2
@export var tilt_lower_limit := -PI / 2

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var _gravity := -30.0

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %Camera3D
@onready var _raycast: RayCast3D = %RayCast3D


signal ray_hit(object: Node3D, pos: Vector3, normal: Vector3, operation: String)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("left_click"):
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			return
		_raycast.force_raycast_update()
		if _raycast.is_colliding():
			var collider: Node3D = _raycast.get_collider()
			var collision_point: Vector3 = _raycast.get_collision_point()
			var collision_normal: Vector3 = _raycast.get_collision_normal()
			ray_hit.emit(collider, collision_point, collision_normal, 'delete')
			print('raycast collided with ', collider, 'at ', collision_point)
	if event.is_action_pressed("right_click"):
		_raycast.force_raycast_update()
		if _raycast.is_colliding():
			var collider: Node3D = _raycast.get_collider()
			var collision_point: Vector3 = _raycast.get_collision_point()
			var collision_normal: Vector3 = _raycast.get_collision_normal()
			ray_hit.emit(collider, collision_point, collision_normal, 'add')



func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity


func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x -= _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta

	_camera_input_direction = Vector2.ZERO

	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = y_velocity + _gravity * delta

	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse
	#if _raycast.is_colliding():
		#print('aaaaaaaarhg')
	move_and_slide()

	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
