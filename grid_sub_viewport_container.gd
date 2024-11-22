@tool
extends SubViewportContainer

const START_SCREEN = preload("res://start_screen.tscn")

@export var grid: Grid

@onready var sub_viewport: SubViewport = $SubViewport
var cell_size := Vector2i(192, 192)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var grid_pixels := grid.grid_size * cell_size
	sub_viewport.size_2d_override = Vector2i(grid_pixels)
	sub_viewport.size_2d_override_stretch = true


func _on_game_manager_game_over() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 3).set_delay(1)
	tween.tween_callback(get_tree().change_scene_to_packed.bind(START_SCREEN))
