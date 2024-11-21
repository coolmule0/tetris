extends Control

@export var game_manger: GameManager

@onready var top_label: Label = %TopLabel
@onready var score_label: Label = %ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_score(0)
	game_manger.score_changed.connect(on_score_changed)

func on_score_changed(new_score: int):
	set_score(new_score)

func set_score(score: int):
	score_label.text = "%06d" % score
