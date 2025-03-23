extends AnimatedSprite2D

func _ready():
	connect("animation_finished", Callable(self, "_on_animation_finished")) #how we make our code connect a node on its own, not just in the editor
	frame = 0
	play("Animate")

func _on_animation_finished():
	queue_free()
