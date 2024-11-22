@tool
class_name GridVisualiser
extends Node2D

@export var grid: Grid

var empty_cell: Texture = preload("res://Assets/blocks/Grid.png")
var cell_size := Vector2i(192, 192)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the background
	var grid_size = grid.grid_size
	for x: int in grid_size.x:
		for y: int in grid_size.y:
			# pixel position - include cell offset so 0,0 is the start of the grid
			var pixel_position = cell_size * Vector2i(x, y) + cell_size / 2
			
			var c := Sprite2D.new()
			add_child(c)
			c.position = pixel_position
			c.texture = empty_cell
			c.z_index = -1
	pass # Replace with function body.

var blocks: Array

func _on_grid_grid_updated() -> void:
	render_grid()

# Given an x,y index on the grid, get the coordinates in screen space
func grid_to_screen_pos(pos: Vector2i) -> Vector2i:
	return cell_size * pos #+ cell_size / 2

# An ineffecient way of showing what the grid looks like
func render_grid():
	# Remove previous blocks
	for b in blocks:
		b.queue_free()
	blocks.resize(0)
	
	var grid_size = grid.grid_size
	for y: int in grid_size.y:
		for x: int in grid_size.x: 
			if not grid.get_cell(Vector2i(x,y)).is_empty:
				var c := Sprite2D.new()
				add_child(c)
				blocks.append(c)
				var screen_position := grid_to_screen_pos(Vector2i(x,y))
				c.position = screen_position + cell_size / 2
				c.texture = grid.get_cell(Vector2i(x,y)).tex
