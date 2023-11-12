extends Node2D

@onready var pause_menu: Node2D = $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_continue_pressed():
	pause_menu.visible = false
	get_tree().paused = false

func _on_exit_pressed():
	get_tree().quit()
