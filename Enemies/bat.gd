extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@export var ACCELERATION = 80
@export var MAX_SPEED = 25
@export var FRICTION = 200 # NOT FOR MOVEMENT, FOR KNOCKBACK
@export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

const KNOCKBACK_SPEED = 75

var state = CHASE

@onready var sprite = $BatSprite
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO,  FRICTION * delta)
	move_and_slide()
	
	#state machine
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander_state_and_time()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander_state_and_time()
				
			accelerate_towards_point(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander_state_and_time()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400 # soem value makes sure they push away, higher less likly to overlap
	move_and_slide()

func update_wander_state_and_time():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(int(randf_range(1, 3)))

func accelerate_towards_point(point, delta):
	var direction = position.direction_to(point) # START.direction to (END)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle() # shuffles list of states we have passed
	return state_list.pop_front() # grab first value in our shuffled list

func _on_hurtbox_area_entered(area): # "area" is like our hitbox
	stats.health -= area.damage # bat telling stats to do soemthing, call down 
	
	#  knockback code
	var direction = (position - area.owner.position).normalized()
	velocity = direction * KNOCKBACK_SPEED
	# if you do queue_free() here it destroys the bat
	
	hurtbox.create_hit_effect()

func _on_stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
