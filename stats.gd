extends Node

@export var max_health = 1
@onready var health = max_health: # how we create a 'setget' in godot 4
	get:
		return health
	set(value):
		health = value
		if health <= 0:
			emit_signal("no_health")

signal no_health
