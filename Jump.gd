extends PlayerState

@export var speed: float = 30.0

@onready var jump_buffer: RayCast3D = %JumpBuffer

const acceleration: float = 10.0
const JUMP_VELOCITY: float = 15
# Called when the node enters the scene tree for the first time.

func enter():
	var jump_force: float = JUMP_VELOCITY
	if !chara.is_on_floor():
		jump_force *= 1.5
	chara.velocity.y = jump_force
	
func physics_update(delta: float):
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (chara.headY.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	chara.velocity.x = lerp(chara.velocity.x, direction.x * speed * chara.speed_multiplier, delta * acceleration)
	chara.velocity.z = lerp(chara.velocity.z, direction.z * speed * chara.speed_multiplier, delta * acceleration)
	
	if !chara.is_on_floor():
		return "Falling"

		
func input(event: InputEvent):
	if event.is_action_pressed("Dash"):
		return "Dash"
	
