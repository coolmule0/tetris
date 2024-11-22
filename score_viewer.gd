extends Control

@export var game_manger: GameManager

@onready var top_label: Label = %TopLabel
@onready var score_label: Label = %ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_score(0)
	set_highscore(game_manger.highscore)
	game_manger.score_changed.connect(on_score_changed)
	game_manger.highscore_changed.connect(on_highscore_changed)

func on_score_changed(new_score: int):
	set_score(new_score)

func set_score(score: int):
	score_label.text = "%06d" % score

func on_highscore_changed(new_highscore: int):
	set_highscore(new_highscore)

func set_highscore(new_highscore: int):
	top_label.text = "%06d" % new_highscore
