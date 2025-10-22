extends CharacterBody2D

class_name player

@export_group("Locomotion") #não entendi o que é
@export var speed = 200
@export var jump_velocity = -350
@export var run_speed_damping = 0.5

@export_group("Stomping Enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -250

var is_dead = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	if Input.is_action_just_pressed("jump") and velocity.y < 0:
		velocity.y *= 0.5
		
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		
		
	$AnimatedSprite2D.trigger_animation(velocity, direction)

	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not (area is Enemy) and is_dead:
		return
		
	if area is Koopa && (area as Koopa).in_a_shell:
		(area as Koopa)._on_stomp(global_position)



	# Aqui sim entra a lógica do ângulo
	var angle = rad_to_deg(position.angle_to_point((area as Enemy).position))

	if angle > min_stomp_degree and angle < max_stomp_degree:
		(area as Enemy)._die()
	else:
		_die()
	
	
func _die():
	is_dead = true
	$AnimatedSprite2D.play("small_death")
	set_collision_layer_value(1, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_physics_process(false)
	
	var death_tween = get_tree().create_tween()
	death_tween.tween_property(self,"position", position + Vector2(0, -25), 0.4)
	death_tween.tween_property(self,"position", position + Vector2(0, 300), 2)
	death_tween.tween_callback(func (): get_tree().reload_current_scene())
