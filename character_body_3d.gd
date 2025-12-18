extends CharacterBody3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		velocity.x = 50
	elif event.is_action_pressed("ui_right"):
		velocity.x = -50
	elif event.is_action_pressed("ui_down"):
		velocity.z = 50
		
func _physics_process(delta: float) -> void:
	move_and_slide()
