extends Control


func _on_play_pressed() -> void:
	vida.vidas = 3
	get_tree().change_scene_to_file("res://Cenas/historia_1.tscn")
