extends PlayerState

@export var speed: float = 30.0


@onready var jump_buffer: RayCast3D = %JumpBuffer
@onready var fall_buffer: Timer = %FallBuffer
@onready var cracks: AudioStreamPlayer3D = %Cracks
@onready var camera: Camera3D = %Camera3D

const GRAVITY: float = 30.0
const acceleration: float = 10.0

var double_jump_enabled: bool = true
	

	
func physics_update(delta: float):
	chara.velocity.y -= GRAVITY * delta
	if jump_buffer.is_colliding():
		if chara.velocity.y < -70:
			cracks.play()
			camera.shake(2.0)
	if chara.is_on_floor():
		double_jump_enabled = true
		return "Walk"
		
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (chara.headY.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	chara.velocity.x = lerp(chara.velocity.x, direction.x * speed * chara.speed_multiplier, delta * acceleration)
	chara.velocity.z = lerp(chara.velocity.z, direction.z * speed * chara.speed_multiplier, delta * acceleration)
	
func input(event: InputEvent):
	
	if Input.is_action_just_pressed("jump"):
		if jump_buffer.is_colliding() or !fall_buffer.is_stopped():
			double_jump_enabled = true
			return "Jump"
			
		if !jump_buffer.is_colliding() and double_jump_enabled and chara.velocity.y < 0:
			double_jump_enabled = false
			return "Jump"
			
	if event.is_action_pressed("Dash"):
		return "Dash"
