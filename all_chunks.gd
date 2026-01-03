extends Node3D





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_chunk = load("res://chunk.tscn")
	var chunk_amount: Vector3i = Vector3i(8, 4, 8)
	for x in range(chunk_amount.x):
		for y in range(chunk_amount.y):
			for z in range(chunk_amount.z):
				var instantiated_chunk = new_chunk.instantiate()
				instantiated_chunk.position = Vector3i(x*Globals.chunk_size, y*Globals.chunk_size, z*Globals.chunk_size)
				instantiated_chunk.global_pos = Vector3i(x*Globals.chunk_size, y*Globals.chunk_size, z*Globals.chunk_size)
				add_child(instantiated_chunk)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
