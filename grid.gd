@tool
class_name Grid
extends Node2D

@export var grid_size: Vector2i

var _landed: Array[Block]

class Block:
	var is_empty := true
	var tex: Texture

signal grid_updated
signal line_cleared(row_number: int)

#@export var grid_visualiser: GridVisualiser
#@export var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# how many elements in this grid rectangle?
	var size := grid_size.x * grid_size.y
	_landed.resize(size)
	for y: int in grid_size.y:
		for x: int in grid_size.x:
			_landed[_get_idx(Vector2i(x,y))] = Block.new()

# Insert a tetronimo into the grid at given spawn position
func add_shape(shape: PieceData, spawn_position := Vector2i(0,0)):
	for c in shape.get_cells():
		var b := Block.new()
		b.tex = shape.texture
		b.is_empty = false
		set_cell(c + spawn_position, b)
	grid_updated.emit()
	
	check_lines()

## Add a filled cell to a particular coord in the grid
#func add_cell(pos: Vector2i, tex: Texture):
	#_landed[_get_idx(pos)].is_empty = false
	#_landed[_get_idx(pos)].tex = tex

func set_cell(pos: Vector2i, block: Block):
	_landed[_get_idx(pos)] = block

## Get array index from 2d grid position. For use in accessing grid array data
func _get_idx(pos: Vector2i) -> int:
	return pos.y * grid_size.x + pos.x

func get_cell(pos: Vector2i) -> Block:
	return _landed[_get_idx(pos)]

# Check if a row is full
func is_row_full(row_index):
	for x in range(grid_size.x):
		if get_cell(Vector2i(x,row_index)).is_empty == true:
			return false
	return true

## See if any lines are complete
func check_lines():
	var cleared_lines: Array[int]
	# search from bottom to top
	for y: int in range(grid_size.y):
		if is_row_full(y):
			line_cleared.emit(y)
			cleared_lines.append(y)
	
	# for each line cleared in reverse order
	for c: int in cleared_lines:
		for row: int in range(c, 1, -1): # Start from the cleared row, move upward
			for x in range(grid_size.x):
				var moved_contents := get_cell(Vector2i(x,row-1))
				set_cell(Vector2i(x,row), moved_contents)
		
		# clear the top row
		for x in range(grid_size.x):
			var pos := Vector2i(x,0)
			set_cell(pos, Block.new())
	grid_updated.emit()
