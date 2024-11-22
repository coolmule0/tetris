class_name GameManager
extends Node
# Handles the game state

signal level_changed(new_level: int)
signal lines_changed(new_lines: int)
signal score_changed(new_lines: int)

## Level the player has reached
var level: int = 0:
	set(new_val):
		level = new_val
		level_changed.emit(new_val)
		set_move_time()
## How many lines cleared
var lines: int = 0:
	set(new_val):
		lines = new_val
		lines_changed.emit(new_val)
var score: int = 0:
	set(new_val):
		score = new_val
		score_changed.emit(new_val)

@onready var move_timer: Timer = $MoveTimer

@export var spawn_queue: SpawnQueue
@export var grid_visualiser: GridVisualiser
@export var grid: Grid

signal move_timeout
signal game_over

const TETRONIMO = preload("res://Tetronimo.tscn")

const SPAWN_LOCATION := Vector2i(3, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_tetronimo()
	grid.line_cleared.connect(on_grid_line_cleared)
	pass # Replace with function body.


func _on_move_timer_timeout() -> void:
	move_timeout.emit()

func spawn_tetronimo():
	var new_piece_type := spawn_queue.serve()
	var t = TETRONIMO.instantiate() as Tetronimo
	t.grid_visualiser = grid_visualiser
	t.grid = grid
	t.game_manager = self
	t.set_cells(new_piece_type)
	grid_visualiser.add_child(t)
	t.piece_locked.connect(on_tetronimo_locked)
	t.set_grid_position(SPAWN_LOCATION)
	t.pivot = new_piece_type.pivot_point
	
	# check the spawned cell locations are free
	for c: Vector2i in new_piece_type.get_cells():
		if not grid.get_cell(c + SPAWN_LOCATION).is_empty:
			game_over.emit()
			t.set_process_input(false)
			move_timer.stop()


func on_tetronimo_locked():
	spawn_tetronimo()

func on_grid_line_cleared(_line_id):
	lines += 1
	score += 10
	
	# Adjust level if necessary
	@warning_ignore("integer_division")
	var new_level = floor(lines / 10)
	if new_level != level:
		level = new_level

## calculates and sets the move timer for the given level
func set_move_time():
	var time = pow(0.8 - ((level-1) * 0.007), level-1)
	move_timer.wait_time=time
