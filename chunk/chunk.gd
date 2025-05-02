extends Node3D

@export_category("Chunk Settings")
@export var chunk_size: int = 32
var chunk_area: int = chunk_size ** 2
var chunk_volume: int = chunk_size ** 3



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
