extends State
class_name GroundState

@onready var player: Player = $"../.."

func enter_state():
	pass

func physics_update(delta) -> void:
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self,"AirState")
	if Input.is_action_just_pressed("attack"):
		Transitioned.emit(self,"AttackState")
