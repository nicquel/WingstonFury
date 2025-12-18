extends Node
class_name StateManager

@export var target: Node = get_parent()
var current_state: State
@onready var states: Dictionary = {}
@export var starting_state: String = "Idle"

func _change_state(new_state: String):
	if current_state:
		current_state.exit()
		
	if states.get(new_state) == null:
		print("State '" + str(new_state) + "' for '" + str(target) + "' does not exist")
		return
		
	current_state = states.get(new_state)
	var state = await current_state.enter()
	
	if state:
		_change_state(state)

func _ready() -> void:
	for child in get_children():
		states[child.name] = child
		child.parent = target
	# Initialize with a default state of idle

	_change_state(starting_state)
	
func _physics_process(delta: float) -> void:
	var new_state = current_state.physics_update(delta)
	if new_state:
		_change_state(new_state)

func _input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		_change_state(new_state)

func _process(delta: float) -> void:
	var new_state = current_state.update(delta)
	if new_state:
		_change_state(new_state)
