extends Node

func _on_historia_fim_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Cenas/parabens_fim.tscn")


func _on_fundo_morte_body_entered(body: Node2D) -> void:
	if(body.is_dead == false):
		body._die()
