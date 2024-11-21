extends Control

@export var game_manger: GameManager

@onready var lines_label: Label = %LinesLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_lines(0)
	game_manger.lines_changed.connect(on_lines_changed)

func on_lines_changed(new_lines: int):
	set_lines(new_lines)

func set_lines(lines: int):
	lines_label.text = "%03d" % lines
