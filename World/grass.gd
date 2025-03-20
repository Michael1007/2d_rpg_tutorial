extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var GrassEffect = load("res://Effects/grass_effect.tscn")
		var grassEffect = GrassEffect.instantiate() # INSTANCE of our SCENE
		var world = get_tree().current_scene
		world.add_child(grassEffect) # BE SURE we are using the INSTACE here
		grassEffect.global_position = global_position # telling where to place the animation
		
		queue_free() # how we destroy items from memory, adds to a queue until end of frame to remove
