extends Node2D

@export var wander_range = 32 # allows us to change the range in which each enemy can wander individually

@onready var start_position = global_position # need to use onready var to get position of wander controller once its attatched to the enemy, basically get pos of enemy
@onready var target_position = global_position # position enemy wander's towards

@onready var timer = $Timer

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	target_position = start_position + target_vector # never wander too far from start position
	
func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)

func _on_timer_timeout() -> void:
	update_target_position()
