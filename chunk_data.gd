extends Node


const chunk_size: int = 16
const voxel_ids: Dictionary[String, int] = {"empty": 0, "used": 1}
var chunk_data = []

@onready var chunk_pos: Vector3i = get_parent().chunk_pos


@onready var noise = FastNoiseLite.new()

func generate_chunks():
	for x in chunk_size:
		for y in chunk_size:
			for z in chunk_size:
				if noise.get_noise_2d(x+chunk_pos[0]*chunk_size,z+chunk_pos[2]*chunk_size) + 1.0/y+chunk_pos[2]*chunk_size > 0.5:
					chunk_data[x][y][z] = 1




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
