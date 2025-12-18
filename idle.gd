extends PlayerState

@onready var fall_buffer: Timer = %FallBuffer

func physics_update(delta: float):
	if !chara.is_on_floor():
		fall_buffer.start()
		return "Falling"
		
	chara.velocity.x = lerp(chara.velocity.x, 0.0, delta * 7.0)
	chara.velocity.z = lerp(chara.velocity.z, 0.0, delta * 7.0)


		
func input(event: InputEvent):
	
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir:
		return "Walk"
		
	if Input.is_action_pressed("jump") and (chara.is_on_floor()):
		return "Jump"
	
	if event.is_action_pressed("Ctrl"):
		return "Slide"
		
	if event.is_action_pressed("Dash"):
		return "Dash"
