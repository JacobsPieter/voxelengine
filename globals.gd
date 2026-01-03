extends Node

const chunk_size = 16
@onready var noise = FastNoiseLite.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		noise.noise_type = FastNoiseLite.TYPE_PERLIN



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
