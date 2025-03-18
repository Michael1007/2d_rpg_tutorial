# Code tutorial by Heartbeast
extends CharacterBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# When ACCELERATION was 200, it felt like we were on ice. Could be useful
const ACCELERATION = 10
const MAX_SPEED = 100
const FRICTION = 10

# Velocity = the x and y position combined
var vel = Vector2.ZERO

# Called when the node enters the scene tree for the first time
#func _ready():
	#print("Hello world.")

# Look at "Search help" in top bar to see what this function does.
# "delta" is used for real world time, NOT framerate
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# multipy delta whenver you have something that changes over time
	if input_vector != Vector2.ZERO:
		vel += input_vector * ACCELERATION * delta
		vel = vel.limit_length(MAX_SPEED * delta)
	else:
		vel = vel.move_toward(Vector2.ZERO, FRICTION * delta)
	
	#print(vel)
	move_and_collide(vel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
