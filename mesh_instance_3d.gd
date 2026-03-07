extends MeshInstance3D


@onready var chunkdata = %ChunkData

const FACE_NORMALS = [
	Vector3( 0,  0, -1), # achter
	Vector3( 0,  0,  1), # voor
	Vector3(-1,  0,  0), # links
	Vector3( 1,  0,  0), # rechts
	Vector3( 0, -1,  0), # onder
	Vector3( 0,  1,  0)  # boven
]



const FACE_DEFINITIONS = [
	{
		"normal": Vector3(0, 0, -1),
		"neighbor_offset": Vector3i(0, 0, -1),
		"verts": [
			Vector3(0, 0, 0),
			Vector3(1, 0, 0),
			Vector3(1, 1, 0),
			Vector3(0, 1, 0)
		]
	},
	{
		"normal": Vector3(0, 0, 1),
		"neighbor_offset": Vector3i(0, 0, 1),
		"verts": [
			Vector3(0, 0, 1),
			Vector3(0, 1, 1),
			Vector3(1, 1, 1),
			Vector3(1, 0, 1)
		]
	},
	{
		"normal": Vector3(-1, 0, 0),
		"neighbor_offset": Vector3i(-1, 0, 0),
		"verts": [
			Vector3(0, 0, 1),
			Vector3(0, 0, 0),
			Vector3(0, 1, 0),
			Vector3(0, 1, 1)
		]
	},
	{
		"normal": Vector3(1, 0, 0),
		"neighbor_offset": Vector3i(1, 0, 0),
		"verts": [
			Vector3(1, 0, 0),
			Vector3(1, 0, 1),
			Vector3(1, 1, 1),
			Vector3(1, 1, 0)
		]
	},
	{
		"normal": Vector3(0, -1, 0),
		"neighbor_offset": Vector3i(0, -1, 0),
		"verts": [
			Vector3(0, 0, 1),
			Vector3(1, 0, 1),
			Vector3(1, 0, 0),
			Vector3(0, 0, 0)
		]
	},
	{
		"normal": Vector3(0, 1, 0),
		"neighbor_offset": Vector3i(0, 1, 0),
		"verts": [
			Vector3(0, 1, 0),
			Vector3(1, 1, 0),
			Vector3(1, 1, 1),
			Vector3(0, 1, 1)
		]
	}
]


func is_solid(data, x: int, y: int, z: int) -> bool:
	if x < 0 or y < 0 or z < 0:
		return false
	if x >= len(data) or y >= len(data[x]) or z >= len(data[x][y]):
		return false
	return data[x][y][z] != 0



func get_vertices(data) -> Dictionary:
	var vertices: Array[Vector3] = []
	var normals: Array[Vector3] = []
	var indices: Array[int] = []

	var current_index := 0

	for x in range(len(data)):
		for y in range(len(data[x])):
			for z in range(len(data[x][y])):
				if data[x][y][z] == 0:
					continue

				var voxel_pos := Vector3i(x, y, z)
				var offset := Vector3(x, y, z)

				for face in FACE_DEFINITIONS:
					var neighbor_pos = voxel_pos + face["neighbor_offset"]

					if is_solid(
						data,
						neighbor_pos.x,
						neighbor_pos.y,
						neighbor_pos.z
					):
						continue # ❌ interne face → skip

					for base_vert in face["verts"]:
						vertices.append(base_vert + offset)
						normals.append(face["normal"])

					indices.append_array([
						current_index,
						current_index + 1,
						current_index + 2,
						current_index,
						current_index + 2,
						current_index + 3
					])

					current_index += 4

	return {
		"vertices": vertices,
		"normals": normals,
		"indices": indices
	}






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var surface_array := []
	surface_array.resize(Mesh.ARRAY_MAX)

	var verts := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()

	var mesh_data := get_vertices(chunkdata.chunk_data)

	for v in mesh_data["vertices"]:
		verts.append(v)

	for n in mesh_data["normals"]:
		normals.append(n)

	for i in mesh_data["indices"]:
		indices.append(i)

	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices

	if verts.size() > 0:
		mesh.add_surface_from_arrays(
			Mesh.PRIMITIVE_TRIANGLES,
			surface_array
		)
		create_trimesh_collision()







# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
