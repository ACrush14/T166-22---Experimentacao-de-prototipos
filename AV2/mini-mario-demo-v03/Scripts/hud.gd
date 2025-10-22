extends Control

@onready var vida_1: AnimatedSprite2D = $vida1
@onready var vida_2: AnimatedSprite2D = $vida2
@onready var vida_3: AnimatedSprite2D = $vida3
@onready var timer: Timer = $"../../Timer"
@onready var label_time: Label = $Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(vida.vidas == 2):
		print("morreu, 2 vidas")
		vida_3.hide()
	elif (vida.vidas == 1):
		vida_2.hide()
	elif(vida.vidas == 0):
		vida_1.hide()

	label_time.text = ("Tempo: " + str(int(round(timer.time_left))))


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Cenas/game_over.tscn")
