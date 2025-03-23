extends Area2D

var player = null

func can_see_player():
	return player != null # returns a bool, if player == null, then cannot see player returns false

func _on_body_entered(body: Node2D) -> void: # player body enters zone
	player = body

func _on_body_exited(body: Node2D) -> void: # player body exits zone
	player = null
