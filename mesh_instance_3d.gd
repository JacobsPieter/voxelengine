extends MeshInstance3D


@onready var chunkdata = %ChunkData

const cube_verts = [
	Vector3(0, 0, 0), # 0 achter-onder-links
	Vector3( 1, 0, 0), # 1 achter-onder-rechts
	Vector3( 1,  1, 0), # 2 achter-boven-rechts
	Vector3(0,  1, 0), # 3 achter-boven-links
	Vector3(0, 0,  1), # 4 voor-onder-links
	Vector3( 1, 0,  1), # 5 voor-onder-rechts
	Vector3( 1,  1,  1), # 6 voor-boven-rechts
	Vector3(0,  1,  1)  # 7 voor-boven-links
]

const cube_indices = [# Achtervlak (Z-)
		0, 1, 2,  0, 2, 3,
		# Voorvlak (Z+)
		4, 6, 5,  4, 7, 6,
		# Linkervlak (X-)
		4, 0, 3,  4, 3, 7,
		# Rechtervlak (X+)
		1, 5, 6,  1, 6, 2,
		# Onderkant (Y-)
		4, 5, 1,  4, 1, 0,
		# Bovenkant (Y+)
		3, 2, 6,  3, 6, 7]




func get_vertices(data) -> Array:
	var counter: int = 0
	var vertices: Array = []
	var indices: Array = []
	for x in len(data):
		for y in len(data[x]):
			for z in len(data[x][y]):
				if data[x][y][z] != 0:
					var new_verts: Array = []
					for vert in cube_verts:
						vert += Vector3(x, y, z)
						new_verts.append(vert)
					for vert in new_verts:
						vertices.append(vert)
					for index in cube_indices:
						indices.append(index + counter * 8)
					counter += 1
	return [vertices, indices]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var surface_array: Array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()


	var mesh_v_and_i = get_vertices(chunkdata.chunk_data)




	for vert in mesh_v_and_i[0]:
		verts.append(vert)


	# Eenvoudige UV’s (optioneel)
	for i in range(verts.size()):
		uvs.append(Vector2((i % 2), (i / float(verts.size()))))


	# Schat normale per vertex
	for v in verts:
		normals.append(v.normalized())


	for index in mesh_v_and_i[1]:
		indices.append(index)




	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices


	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
