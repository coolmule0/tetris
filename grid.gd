@tool
class_name Grid
extends Node2D

@export var grid_size: Vector2i

var _grid: Array[Block]

class Block:
	var empty := true
	var tex: Texture

const L = preload("res://tetronimos/L.tres") as Tetronimo

signal grid_updated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# how many elements in this grid rectangle?
	var size := grid_size.x * grid_size.y
	_grid.resize(size)
	for y: int in grid_size.y:
		for x: int in grid_size.x:
			_grid[_get_idx(Vector2i(x,y))] = Block.new()
	
	# debug just add something at the start
	add_shape(L)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_block():
	pass

# Insert a tetronimo into the grid at given spawn position
func add_shape(shape: Tetronimo, spawn_position := Vector2i(0,0)):
	#var cells := shape.get_cells()
	#var new_cells := []
	for c in shape.get_cells():
		add_cell(c + spawn_position, shape.texture)
	grid_updated.emit()

# Add a cell to a particular coord in the grid
func add_cell(pos: Vector2i, tex: Texture):
	_grid[_get_idx(pos)].empty = false
	_grid[_get_idx(pos)].tex = tex

## Get array index from 2d grid position. For use in accessing grid array data
func _get_idx(pos: Vector2i) -> int:
	return pos.y * grid_size.x + pos.x

func get_cell(pos: Vector2i) -> Block:
	return _grid[_get_idx(pos)]

func spawn_tetronimo(type: Tetronimo.Shapes, spawn_position := Vector2i(0, 0)):
	
	pass
