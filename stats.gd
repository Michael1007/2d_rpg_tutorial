extends Node

@export var max_health = 1: set = set_max_health
@onready var health = max_health: get = get_health, set = set_health # how we create a 'setget' in godot 4

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func get_health():
		return health

func set_health(value):
	health = value
	emit_signal("health_changed", health) # emit signal with new value
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	if health:
		self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
