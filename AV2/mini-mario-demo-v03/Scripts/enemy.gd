extends Area2D

class_name Enemy

@export var h_speed = 20
@export var v_speed = 100
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2de: RayCast2D = $RayCast2DE
@onready var ray_cast_2dd: RayCast2D = $RayCast2DD
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction = 1
func _process(delta: float) -> void:
	position.x -= h_speed * delta * direction
	if !ray_cast_2d.is_colliding():
		position.y += v_speed * delta
	if ray_cast_2de.is_colliding():
		direction = -1
	if ray_cast_2dd.is_colliding():
		direction = 1
		
func _die():
	h_speed = 0
	v_speed = 0
	animated_sprite_2d.play("Dead")
	$MorteSlime.play()

func _die_from_hit():
	h_speed = 0
	v_speed = 0
	rotation_degrees = 180
	
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	
	var die_tween = get_tree().create_tween()
	die_tween.tween_property(self, "position", position + Vector2(0, -25), .2)
	die_tween.chain().tween_property(self, "position", position + Vector2(0, 500), 4)
	
	
