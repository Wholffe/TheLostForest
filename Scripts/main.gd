extends Node2D

@onready var pause_menu: Node2D = $Camera2D/PauseMenu

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		pause_menu.visible = not pause_menu.visible
		get_tree().paused = not get_tree().paused
