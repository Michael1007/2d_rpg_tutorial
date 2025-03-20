# Code tutorial by Heartbeast
extends CharacterBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# When ACCELERATION was 200, it felt like we were on ice. Could be useful
const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

# enumeration: setting "variables" that cannot change. 
# automatically created with values (0, 1, 2, etc.)
enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
# Velocity = the x and y position combined
var vel = Vector2.ZERO

# Once the game is ready, this will be set up and ready to go (an "onready" variable)
@onready var animationPlayer = $AnimationPlayer # '$' is shorthand for path to a node, which is in the same scene
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback") # Stores what we hvae set up in root, can access that info

func _ready():
	animationTree.active = true

func _process(delta):
	match state: # acts like a switch statement
		MOVE:
			move_state(delta) # beginning of a state machine (only one block of code is run at once
		ROLL:
			pass
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# multipy delta whenver you have something that changes over time
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector) # set blend position for idle
		animationTree.set("parameters/Run/blend_position", input_vector) # set blend position for run
		animationTree.set("parameters/Attack/blend_position", input_vector) 
		# ^^^NOT in attack state because our input vector is not in attack state
		# also we dont want them to change direction of attack mid animation
		
		animationState.travel("Run")
		vel = vel.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		vel = vel.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = vel

	move_and_slide()
	vel = velocity
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	vel = Vector2.ZERO # so they don't move with friction when attack
	velocity = vel
	move_and_slide()
	vel = velocity
	
	animationState.travel("Attack")
	
func attack_animation_finish():
	state = MOVE
