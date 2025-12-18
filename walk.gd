extends PlayerState

@export var speed: float = 30.0
const acceleration: float = 10.0
@onready var fall_buffer: Timer = %FallBuffer


func physics_update(delta: float):
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (chara.headY.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	chara.velocity.x = lerp(chara.velocity.x, direction.x * speed * chara.speed_multiplier, delta * acceleration)
	chara.velocity.z = lerp(chara.velocity.z, direction.z * speed * chara.speed_multiplier, delta * acceleration)
	if !chara.is_on_floor():
		fall_buffer.start()
		return "Falling"
		
	if not direction:
		return "Idle"
	
func input(event: InputEvent):
	if Input.is_action_pressed("jump") and (chara.is_on_floor()):
		return "Jump"

	if event.is_action_pressed("Ctrl"):
		return "Slide"
		
	if event.is_action_pressed("Dash"):
		return "Dash"
	
