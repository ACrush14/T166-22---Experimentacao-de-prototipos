extends Enemy

class_name SlimeRed

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var slime_full = preload("res://Collisions/Slime_Red.tres")
var slime_small = preload("res://Collisions/Slime_Red_Small.tres")
var slime_small_position = Vector2(0, 5)
var slime_red_small = false
@export var slide_speed = 200

func _ready():
	collision_shape_2d.shape = slime_full
	
func _die():
	if !slime_red_small:
		slime_red_small = true
		collision_shape_2d.set_deferred("shape", slime_small)
		collision_shape_2d.set_deferred("position", slime_small_position)
		animated_sprite_2d.play("Dead") # vem do Enemy.gd
	else:
		super._die()
	
func _on_stomp(player_position: Vector2):
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(4, true)
	set_collision_mask_value(3, true)
	
	var movement_direction = 1 if player_position.x <= global_position.x else -1
	h_speed = -movement_direction * slide_speed


func _on_area_entered(area: Area2D) -> void:
	if area is SlimeRed and (area as SlimeRed).slime_red_small and (area as SlimeRed).h_speed != 0:
		_die_from_hit()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
