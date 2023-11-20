extends State
class_name AirState

@onready var player: Player = $"../.."

func enter_state():
	pass

func physics_update(delta) -> void:
	await get_tree().create_timer(0.1).timeout
	if player.is_on_floor():
		Transitioned.emit(self,"GroundState")
