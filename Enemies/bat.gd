extends CharacterBody2D

const KNOCKBACK_SPEED = 120

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO,  200 * delta)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	var direction = (position - area.owner.position).normalized()
	velocity = direction * KNOCKBACK_SPEED
	# if you do queue_free() here it destroys the bat
