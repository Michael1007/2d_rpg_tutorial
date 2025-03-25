# Code tutorial by Heartbeast
extends CharacterBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

# When ACCELERATION was 200, it felt like we were on ice. Could be useful
@export var ACCELERATION = 500
@export var MAX_SPEED = 80
@export var ROLL_SPEED = 125
@export var FRICTION = 500

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
var roll_vector = Vector2.DOWN
var stats = PlayerStats

# Once the game is ready, this will be set up and ready to go (an "onready" variable)
@onready var animationPlayer = $AnimationPlayer # '$' is shorthand for path to a node, which is in the same scene
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback") # Stores what we hvae set up in root, can access that info
@onready var hurtbox = $Hurtbox
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer


func _ready():
	stats.connect("no_health", Callable(self, "queue_free"))
	animationTree.active = true
	#blinkAnimationPlayer.play("Stop")

func _physics_process(delta):
	match state: # acts like a switch statement
		MOVE:
			move_state(delta) # beginning of a state machine (only one block of code is run at once
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# multipy delta whenver you have something that changes over time
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector # ONLY do if vector isn't zero
		animationTree.set("parameters/Idle/blend_position", input_vector) # set blend position for idle
		animationTree.set("parameters/Run/blend_position", input_vector) # set blend position for run
		animationTree.set("parameters/Attack/blend_position", input_vector) 
		animationTree.set("parameters/Roll/blend_position", input_vector) 
		# ^^^NOT in attack state because our input vector is not in attack state
		# also we dont want them to change direction of attack mid animation
		
		animationState.travel("Run")
		vel = vel.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		vel = vel.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move_and_slide()

func attack_state(_delta):
	vel = Vector2.ZERO # so they don't move with friction when attack
	move()
	animationState.travel("Attack")
	
func move():
	velocity = vel
	move_and_slide()
	vel = velocity
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finish():
	state = MOVE

func _on_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instantiate()
	call_deferred("add_audio_to_scene", playerHurtSound)

func add_audio_to_scene(sound):
	get_tree().current_scene.add_child(sound)

func _on_hurtbox_invincibility_started() -> void:
	blinkAnimationPlayer.play("Start")

func _on_hurtbox_invincibility_ended() -> void:
	blinkAnimationPlayer.play("Stop")
