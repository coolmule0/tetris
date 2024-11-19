class_name Tetronimo
extends Node2D
### The actual piece the player controls

enum Rotation {CLOCKWISE = 1, ANTICLOCKWISE = -1}

var piece_type: PieceData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(_event):
	if Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("hard_drop"):
		hard_drop()
	elif Input.is_action_just_pressed("rotate_left"):
		rotate_tetromino(Rotation.ANTICLOCKWISE)
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_tetromino(Rotation.CLOCKWISE)

func rotate_tetromino(orientation: Rotation):
	pass

func move(direction: Vector2i):
	pass

func hard_drop():
	pass
