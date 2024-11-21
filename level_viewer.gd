extends Control

@export var game_manger: GameManager

@onready var level_label: Label = %LevelLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_level(0)
	game_manger.level_changed.connect(on_level_changed)

func on_level_changed(new_level: int):
	set_level(new_level)

func set_level(level: int):
	level_label.text = "%02d" % level
