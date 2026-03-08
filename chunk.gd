extends Node3D


@onready var chunk_data = %ChunkData
@onready var mesh = %MeshInstance3D



var global_pos: Vector3i


func update_chunk(pos: Vector3, operation: String) -> void:
	#if operation == 'delete':
	print('here!')
	chunk_data.chunk_data[floor(position.x)][floor(position.y)][floor(position.z)] = 0

	mesh.call_deferred('build_chunk')






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
