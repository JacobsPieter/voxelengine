extends Node


const chunk_size = Globals.chunk_size
const voxel_ids: Dictionary[String, int] = {"empty": 0, "used": 1}
var chunk_data = []






func generate_chunks():
	var parent: Node3D = get_parent()
	for x in chunk_size:
		for y in chunk_size:
			for z in chunk_size:
				var noise_value = Globals.noise.get_noise_2d((x+parent.global_pos.x), (z+parent.global_pos.z))
				if noise_value == 0:
					noise_value = 0.00000001
				if abs(noise_value) * 50 > (y+parent.global_pos.y):
					chunk_data[x][y][z] = 1
				else:
					chunk_data[x][y][z] = 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	for x in chunk_size:
		chunk_data.append([])
		for y in chunk_size:
			chunk_data[x].append([])
			for z in chunk_size:
				chunk_data[x][y].append(0)
	generate_chunks()
	#new_chunk_data[0][0][0] = 1
	#chunk_data[1][0][0] = 1
	#chunk_data[0][1][0] = 1
	#new_chunk_data[0][0][1] = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
