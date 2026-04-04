extends Node3D


@onready var chunk_data = %ChunkData
@onready var mesh = %MeshInstance3D



var global_pos: Vector3i


func update_chunk(pos: Vector3, normal: Vector3, operation: String) -> void:
	if operation == 'delete':
		print('here!')
		print(pos.x,'  ',pos.y,'  ',pos.z)
		chunk_data.chunk_data[floori(pos.x-normal.x/2)%16][floori(pos.y-normal.y/2)%16][floori(pos.z-normal.z/2)%16] = 0

		mesh.call_deferred('build_chunk')



	if operation == 'add':
		print('here!')
		chunk_data.chunk_data[floori(pos.x-normal.x/2)%16+normal.x][floori(pos.y-normal.y/2)%16+normal.y][floori(pos.z-normal.z/2)%16+normal.z] = 11
		mesh.call_deferred('build_chunk')





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
