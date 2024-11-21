class_name Tetronimo
extends Node2D
### The actual piece the player controls

enum Rotation {CLOCKWISE = 1, ANTICLOCKWISE = -1}

@export var piece_type: PieceData
# relative location of each cell
var cell_positions: Array[Vector2i]
var cell_nodes: Array[Node2D]
var cell_texture: Texture
# Where this shape should rotate around
var pivot: Vector2i

# Track where the shape is in the grid
var grid_position: Vector2i

#@export
var grid_visualiser: GridVisualiser
#@export 
var grid: Grid
var game_manager: GameManager

signal piece_locked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	game_manager.move_timeout.connect(on_game_manager_move_timeout)

func set_cells(cell_piece_type: PieceData):
	cell_texture = cell_piece_type.texture
	for c: Vector2i in cell_piece_type.get_cells():
		var s = Sprite2D.new()
		add_child(s)
		s.texture = cell_texture
		s.position = grid_visualiser.grid_to_screen_pos(c) + grid_visualiser.cell_size / 2
		cell_positions.append(c)
		cell_nodes.append(s)
	self.position = grid_visualiser.grid_to_screen_pos(grid_position)

## when the game manager timer expires, move the piece down
func on_game_manager_move_timeout():
	move(Vector2i.DOWN)

func _input(_event):
	if Input.is_action_just_pressed("left"):
		move(Vector2i.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2i.RIGHT)
	elif Input.is_action_just_pressed("down"):
		move(Vector2i.DOWN)
	elif Input.is_action_just_pressed("hard_drop"):
		hard_drop()
	elif Input.is_action_just_pressed("rotate_left"):
		rotate_tetromino(Rotation.ANTICLOCKWISE)
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_tetromino(Rotation.CLOCKWISE)

func rotate_tetromino(orientation: Rotation):
	#var pivot: Vector2i = Vector2i(1,1)
	var rotated_block = []
	
	# calculate the rotated positions
	for c: Vector2i in cell_positions:
		var relative_x := c.x - pivot.x
		var relative_y := c.y - pivot.y
		
		var rotated_x
		var rotated_y
		if orientation == Rotation.CLOCKWISE:
			rotated_x = relative_y
			rotated_y = -relative_x
		else:
			rotated_x = -relative_y
			rotated_y = relative_x
		
		var final_x = rotated_x + pivot.x
		var final_y = rotated_y + pivot.y
		
		rotated_block.append(Vector2i(final_x, final_y))
	
	for c: Vector2i in rotated_block:
		var new_cell_grid_pos = grid_position + c
		
		# out of bounds?
		if new_cell_grid_pos.x < 0 or \
		   new_cell_grid_pos.y < 0 or \
		   new_cell_grid_pos.x > grid.grid_size.x - 1 or \
		   new_cell_grid_pos.y > grid.grid_size.y - 1:
			return
		
		# new position will hit a block
		if grid.get_cell(new_cell_grid_pos).is_empty == false:
			return
	
	# All checks past - rotate it
	for i: int in range(rotated_block.size()):
		cell_positions[i] = rotated_block[i]
		cell_nodes[i].position = grid_visualiser.grid_to_screen_pos(rotated_block[i]) + grid_visualiser.cell_size / 2

func move(direction: Vector2i) -> bool:
	for c: Vector2i in cell_positions:
		var new_cell_grid_pos = grid_position + c + direction
		
		# out of bounds?
		if new_cell_grid_pos.x < 0 or \
		   new_cell_grid_pos.y < 0 or \
		   new_cell_grid_pos.x > grid.grid_size.x - 1 or \
		   new_cell_grid_pos.y > grid.grid_size.y - 1:
			# reached the bottom of the grid
			if new_cell_grid_pos.y > grid.grid_size.y - 1:
				lock()
			return false
		
		# new position will hit a block
		if grid.get_cell(new_cell_grid_pos).is_empty == false:
			# moving down - lock the tile
			if direction == Vector2i.DOWN:
				lock()
			return false
	
	# no issues, so move
	grid_position += direction
	self.position = grid_visualiser.grid_to_screen_pos(grid_position)
	return true

func hard_drop():
	while move(Vector2i.DOWN):
		continue

func lock():
	var grid_positions: Array[Vector2i] = []
	for c: Vector2i in cell_positions:
		grid_positions.append(c + grid_position)
		#grid.add_cell(c + grid_position, cell_texture)
	grid.add_cells(grid_positions, cell_texture)
	piece_locked.emit()
	queue_free()

## Put the tetronimo at a specific grid position
func set_grid_position(pos: Vector2i):
	grid_position = pos
	self.position = grid_visualiser.grid_to_screen_pos(pos)
