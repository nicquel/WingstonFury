extends PlayerState



@export var dash_speed: float = 65
@export var slide_acceleration: float = 0.075
@export var speed: float = 22.0
@export var slide_speed: float = 70

@onready var slide_duration: Timer = %SlideDuration
@onready var animation: AnimationPlayer = %Animation
@onready var ceiling_collider: RayCast3D = %Ceiling_collider

var default_slide_speed: float = slide_speed
var received_input_before_press: Vector2

const ACCELERATION: float = 10.0

func enter():
	if slide_duration.is_stopped():
		slide_speed = default_slide_speed
		received_input_before_press = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if received_input_before_press:
			chara.velocity.x += -chara.camera.global_transform.basis.z.x * dash_speed * chara.speed_multiplier 
			chara.velocity.z += -chara.camera.global_transform.basis.z.z * dash_speed * chara.speed_multiplier

		animation.play("Slide")
		slide_duration.start()
	
func physics_update(delta: float):
	if !Input.is_action_pressed("Ctrl") and !ceiling_collider.is_colliding():

		animation.play_backwards("Slide")
		return "Walk"
		
	elif !Input.is_action_pressed("Ctrl") and ceiling_collider.is_colliding():
		received_input_before_press = Vector2.ZERO
		
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 
	
	if received_input_before_press: 
		direction = (-chara.headY.transform.basis.z).normalized()
		chara.velocity.x = lerp(chara.velocity.x, direction.x * slide_speed * chara.speed_multiplier, delta * ACCELERATION)
		chara.velocity.z = lerp(chara.velocity.z, direction.z * slide_speed * chara.speed_multiplier, delta * ACCELERATION)
	else:
		direction = (chara.headY.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		chara.velocity.x = lerp(chara.velocity.x, direction.x * speed * chara.speed_multiplier, delta * ACCELERATION)
		chara.velocity.z = lerp(chara.velocity.z, direction.z * speed * chara.speed_multiplier, delta * ACCELERATION)
	
	slide_speed = lerp(slide_speed, 0.0, slide_acceleration * delta)
