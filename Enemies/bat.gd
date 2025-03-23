extends CharacterBody2D

const KNOCKBACK_SPEED = 120

@onready var stats = $Stats

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO,  200 * delta)
	move_and_slide()

func _on_hurtbox_area_entered(area): # "area" is like our hitbox
	stats.health -= area.damage # bat telling stats to do soemthing, call down 
	
	#  knockback code
	var direction = (position - area.owner.position).normalized()
	velocity = direction * KNOCKBACK_SPEED
	# if you do queue_free() here it destroys the bat

func _on_stats_no_health() -> void:
	queue_free()
