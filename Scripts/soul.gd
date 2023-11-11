extends Node2D

@onready var animation: AnimatedSprite2D =  $AnimatedSprite2D
var is_collected = false

func _ready():
	animation.play("start")
	await get_tree().create_timer(0.5).timeout
	animation.play("loop")

func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		collect()

func collect():
	is_collected = true
	animation.play("end")
	await get_tree().create_timer(0.5).timeout
	queue_free()
