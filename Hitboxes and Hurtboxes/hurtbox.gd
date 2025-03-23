extends Area2D

const HitEffect = preload("res://Effects/hit_effect.tscn")

signal invincibility_started
signal invincibility_ended

@onready var time = $Timer

var invincible = false:
	get:
		return invincible
	set(value):
		invincible = value
		if invincible == true:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	time.start(duration)

func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene # CANT use parent here, it will be freeing itself
	main.add_child(effect)
	effect.global_position = global_position

func _on_timer_timeout() -> void:
	self.invincible = false # MUST call self because setter will only be called this way

func _on_invincibility_started() -> void:
	set_deferred("monitoring", false)

func _on_invincibility_ended() -> void:
	monitoring = true
