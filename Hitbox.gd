extends Area3D
class_name Hitbox

signal on_damaged(victim: Area3D)
@export var damage_dealer: DamageDealer = DamageDealer.new()

var has_parried: bool = false

func _ready() -> void:
	area_entered.connect(damage)
	

func damage(victim: Area3D) -> void:
	extras(victim)
	hurt(victim)

func hurt(victim:Area3D) -> void:
	if victim is Hurtbox:
		damage_dealer.global_position = global_position
		victim.hit(damage_dealer)
		emit_signal("on_damaged", victim)
		
func extras(victim: Area3D) -> void:
	pass
