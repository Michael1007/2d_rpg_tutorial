extends Node2D

func create_grass_effect():
	var GrassEffect = load("res://Effects/grass_effect.tscn")
	var grassEffect = GrassEffect.instantiate() # INSTANCE of our SCENE
	var world = get_tree().current_scene
	world.add_child(grassEffect) # BE SURE we are using the INSTACE here
	grassEffect.global_position = global_position # telling where to place the animation

func _on_hurtbox_area_entered(area: Area2D) -> void:
	create_grass_effect()
	queue_free()
