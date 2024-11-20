@tool
class_name PieceData
extends Resource

## The orientation/layout of the cells in this tetronimo
@export var shape: Shapes
@export var texture: Texture
@export var pivot_point: Vector2i

const I: Array[Vector2i] = [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(3,0)]
const S: Array[Vector2i] = [Vector2i(0,1), Vector2i(1,1), Vector2i(1,0), Vector2i(2,0)]
const T: Array[Vector2i] = [Vector2i(0,1), Vector2i(1,1), Vector2i(1,0), Vector2i(2,1)]
const O: Array[Vector2i] = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1)]
const Z: Array[Vector2i] = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)]
const J: Array[Vector2i] = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)]
const L: Array[Vector2i] = [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(2,0)]

enum Shapes {I, S, T, O, Z, J, L}

const COLLECTION :={Shapes.I: I, 
					Shapes.S: S, 
					Shapes.T: T, 
					Shapes.O: O, 
					Shapes.Z: Z, 
					Shapes.J: J, 
					Shapes.L: L}

func get_cells() -> Array[Vector2i]:
	return COLLECTION[shape]
