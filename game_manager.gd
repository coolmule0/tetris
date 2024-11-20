class_name GameManager
extends Node
# Handles the game state

## Level the player has reached
var level: int = 0
## How many lines cleared
var lines: int = 0

@onready var move_timer: Timer = $MoveTimer

@export var spawn_queue: SpawnQueue
@export var grid_visualiser: GridVisualiser
@export var grid: Grid

signal move_timeout

const TETRONIMO = preload("res://Tetronimo.tscn")

const SPAWN_LOCATION := Vector2i(3, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_tetronimo()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_move_timer_timeout() -> void:
	move_timeout.emit()

func spawn_tetronimo():
	var new_piece_type = spawn_queue.serve()
	var t = TETRONIMO.instantiate() as Tetronimo
	t.piece_type = new_piece_type
	t.grid_visualiser = grid_visualiser
	t.grid = grid
	t.game_manager = self
	grid_visualiser.add_child(t)
	t.piece_locked.connect(on_tetronimo_locked)
	t.set_grid_position(SPAWN_LOCATION)

func on_tetronimo_locked():
	spawn_tetronimo()
