extends Node3D





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_chunk = load("res://chunk.tscn")
	var chunk_amount: Vector3i = Vector3i(10, 4, 10)
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


func _on_player_ray_hit(object: Node3D, pos: Vector3, normal: Vector3, operation: String) -> void:
	var children = get_children()
	for child in children:
		if object.global_position == child.global_position:
			print('here!')
			child.call_deferred('update_chunk', pos, normal, operation)
			print('here first!')
			break
