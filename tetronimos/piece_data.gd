class_name PieceData
extends Resource

@export var shape: Shapes
@export var texture: Texture

const LINE: Array[Vector2i] = [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(3,0)]

enum Shapes {LINE}

func get_cells() -> Array[Vector2i]:
	return LINE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
