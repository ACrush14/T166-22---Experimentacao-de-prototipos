extends Control

@onready var menu: AudioStreamPlayer2D = $Menu


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(("res://Cenas/historia_1.tscn"))
	$Menu.play()

func _on_quit_pressed() -> void:
	get_tree().quit()
