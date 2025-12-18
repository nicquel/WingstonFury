extends Node
class_name State

@onready var manager: StateManager = get_parent()
@onready var parent: Node3D


func enter():
	pass
	
func exit():
	pass
	
func update(_delta: float):
	return null

func input(_event: InputEvent):
	return null

func physics_update(_delta: float):
	return null
