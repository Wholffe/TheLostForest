extends State
class_name GroundState

@onready var player: Player = $"../.."

func enter_state():
	print("GroundState")

func physics_update(delta) -> void:
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self,"AirState")
