class_name Tetronimo
extends Node2D
### The actual piece the player controls

enum Rotation {CLOCKWISE = 1, ANTICLOCKWISE = -1}

var piece_type: PieceData

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
	for c: Vector2i in piece_type.get_cells():
		var s = Sprite2D.new()
		add_child(s)
		s.texture = piece_type.texture
		s.position = grid_visualiser.grid_to_screen_pos(c) + grid_visualiser.cell_size / 2
	self.position = grid_visualiser.grid_to_screen_pos(grid_position)
	
	game_manager.move_timeout.connect(on_game_manager_move_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	pass

func move(direction: Vector2i):
	for c: Vector2i in piece_type.get_cells():
		var new_cell_grid_pos = grid_position + c + direction
		
		# out of bounds?
		if new_cell_grid_pos.x < 0 or \
		   new_cell_grid_pos.y < 0 or \
		   new_cell_grid_pos.x > grid.grid_size.x - 1 or \
		   new_cell_grid_pos.y > grid.grid_size.y - 1:
			# reached the bottom of the grid
			if new_cell_grid_pos.y > grid.grid_size.y - 1:
				lock()
			return
		
		# new position will hit a block
		if grid.get_cell(new_cell_grid_pos).is_empty == false:
			# moving down - lock the tile
			if direction == Vector2i.DOWN:
				lock()
			return
	
	# no issues, so move
	grid_position += direction
	self.position = grid_visualiser.grid_to_screen_pos(grid_position)

func hard_drop():
	pass

func lock():
	grid.add_shape(piece_type, grid_position)
	piece_locked.emit()
	queue_free()

## Put the tetronimo at a specific grid position
func set_grid_position(pos: Vector2i):
	grid_position = pos
	self.position = grid_visualiser.grid_to_screen_pos(pos)
