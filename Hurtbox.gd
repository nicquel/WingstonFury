@tool
extends Area3D

class_name Hurtbox

signal take_damage(victim: Hurtbox, harmer)
signal dead(victim: Hurtbox, harmer)

@export_group("Hurtbox")

@export var target: Node3D = get_parent()
@export var max_health: float = 100.0
@export var can_be_knockbacked: bool = true
@export var hit_delay: bool = false:
	set(value):
		hit_delay = value
		# This function tells the editor to re-evaluate the properties,
		# which will trigger _validate_property again.
		notify_property_list_changed()
		
@export_range(0.0, 1.0) var hit_delay_timer: float = 0.4


@onready var health: float = max_health

var knockback_decay = 0.85 

# This is the function other objects will call to apply knockback
func apply_knockback(pos: Vector3, force: float):
	if force != 0.0:

		var direction: Vector3 = (target.global_position - pos)
		var distance = direction.length()
		var falloff = clamp((distance / 2.0), 0.1, 1.0) # adjust 2.0 for range
		var scaled_force = force * falloff
		var knockback_vector: Vector3 = direction * scaled_force
		target.velocity = knockback_vector
		
# This function is called by the editor to determine how a property should be displayed.
# It needs @tool to run in the editor.
func _validate_property(property: Dictionary) -> void:
	if property.name == "hit_delay_timer" and not hit_delay:
		# This makes the property grayed out and un-editable.
		property.usage = PROPERTY_USAGE_READ_ONLY

func hit(harmer: DamageDealer) -> void:
	if harmer != null:
		health -= harmer.damage
		extras()
		apply_knockback(harmer.global_position, harmer.knockback_force)
		emit_signal("take_damage", self, harmer)
		
		if health <= 0:
			death(self, harmer)
			
		if hit_delay:
			monitorable = false
			await get_tree().create_timer(hit_delay_timer).timeout
			monitorable = true
			
func extras() -> void:
	pass
	
func death_extras() -> void:
	pass
	
func death(victim: Hurtbox, harmer) -> void:
	emit_signal("dead", self, harmer)

	return
