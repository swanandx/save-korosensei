extends RigidBody2D

export var min_speed = 150
export var max_speed = 350


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
