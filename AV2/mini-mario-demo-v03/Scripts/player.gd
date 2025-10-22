extends CharacterBody2D

class_name Player

@onready var camera = get_node("../Camera2D")
#@onready var vida = get_node("../Vidas")
@export_group("Locomotion")
@export var speed = 200
@export var jump_velocity = -350
@export var run_speed_damping = 3
@export var deceleration = 800


@export_group("Stomping Enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -150

var is_dead = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var respawn_position: Vector2 = Vector2(-71, -60)

func _ready() -> void:
	global_position = respawn_position
	print("Ready")

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		$Pulo.play()
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
		
	var direction = Input.get_axis("left", "right")
	
	if direction != 0:
		# Acelera na direção do input
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		# Suavemente desacelera até parar
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		
	$Sprites.trigger_animation(velocity, direction)
		
	move_and_slide()
	
	process_camera_bounds()
	
func process_camera_bounds():
	if global_position.x > camera.position.x and global_position.y <= 0:
		camera.position.x = global_position.x
	
	var camera_left_bound = 8 + camera.position.x - get_viewport_rect().size.x / 2 / camera.zoom.x

	if global_position.x <= camera_left_bound:
		velocity.x = 0
		global_position.x = camera_left_bound + .001
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if not (area is Enemy) or is_dead:
		return
		
	if area is SlimeRed and (area as SlimeRed).slime_red_small:
		(area as SlimeRed)._on_stomp(global_position)
		return

	var dir = (area as Enemy).global_position - global_position
	var angle = rad_to_deg(Vector2.RIGHT.angle_to(dir))
	
	if angle > min_stomp_degree and angle < max_stomp_degree:
		(area as Enemy)._die()
		velocity.y = stomp_y_velocity
	else:
		_die()
		
func _die():
	is_dead = true
	vida.perder_vida()
	set_physics_process(false)
	print_debug("Chamou _die(), is_dead=", is_dead)
	$Sprites.play("Death")
	$Morte.play()
	print_debug("Vidas restantes: %d" % vida.vidas)

	


	var death_tween = get_tree().create_tween()
	death_tween.tween_property(self, "global_position", global_position + Vector2(0, -48), 0.5)
	death_tween.chain().tween_property(self, "global_position", global_position + Vector2(0, 256), 1)
	death_tween.tween_callback(func(): respawn())
	if vida.vidas <= 0:
		await death_tween.finished
		print("GAME OVER")
		get_tree().change_scene_to_file("res://Cenas/game_over.tscn")
		
	

func respawn():
	global_position = respawn_position
	velocity = Vector2.ZERO
	is_dead = false
	set_physics_process(true)
	
	
