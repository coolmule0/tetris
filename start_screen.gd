extends Control

const LEVEL_LOCATION = "res://level.tscn"

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_LOCATION)
