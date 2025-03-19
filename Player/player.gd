# Code tutorial by Heartbeast
extends CharacterBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# When ACCELERATION was 200, it felt like we were on ice. Could be useful
const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

# Velocity = the x and y position combined
var vel = Vector2.ZERO

# Once the game is ready, this will be set up and ready to go (an "onready" variable)
@onready var animationPlayer = $AnimationPlayer # '$' is shorthand for path to a node, which is in the same scene

# Look at "Search help" in top bar to see what this function does.
# "delta" is used for real world time, NOT framerate
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# multipy delta whenver you have something that changes over time
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("RunRight") # in this if statement is when we are moving
		else:
			animationPlayer.play("RunLeft")
		vel = vel.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("IdleRight")
		vel = vel.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = vel
	#print(vel)
	move_and_slide()
	vel = velocity
