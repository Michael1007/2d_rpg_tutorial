extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200 # NOT FOR MOVEMENT, FOR KNOCKBACK

enum {
	IDLE,
	WANDER,
	CHASE
}

const KNOCKBACK_SPEED = 120

var state = CHASE

@onready var sprite = $BatSprite
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO,  FRICTION * delta)
	move_and_slide()
	
	#state machine
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		WANDER:
			pass
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position) # START.direction to (END)
				#var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	
	move_and_slide()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_hurtbox_area_entered(area): # "area" is like our hitbox
	stats.health -= area.damage # bat telling stats to do soemthing, call down 
	
	#  knockback code
	var direction = (position - area.owner.position).normalized()
	velocity = direction * KNOCKBACK_SPEED
	# if you do queue_free() here it destroys the bat

func _on_stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
