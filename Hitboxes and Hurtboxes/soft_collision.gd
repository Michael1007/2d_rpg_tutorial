extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0 # returns true if collision occurs
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0] # get the first area that we are colliding with, ignore the others
		push_vector = area.global_position.direction_to(global_position)
	return push_vector
