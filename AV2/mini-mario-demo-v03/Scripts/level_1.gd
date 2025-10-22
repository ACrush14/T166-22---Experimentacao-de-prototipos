extends Node

func _on_historia_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Cenas/historia_2.tscn")

func _on_fundo_morte_body_entered(body: Player) -> void:
	if(body.is_dead == false):
		body._die()
