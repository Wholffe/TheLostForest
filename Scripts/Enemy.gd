extends CharacterBody2D

const JUMP_VELOCITY = -400.0
@export var SPEED = 50.0
@export var enemy_hp = 3

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
var direction = 1
var is_hit = false

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	check_status()
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if(!is_dead and !is_hit):
		if is_on_wall():
			direction *= -1
			animation.flip_h = !animation.flip_h
		velocity.x = SPEED * direction
		animation.play("move")
		move_and_slide()

func check_status():
	if(enemy_hp<=0):
		kill_enemy()

func kill_enemy():
	is_dead = true
	animation.stop()
	animation.play("death")
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(1.5).timeout
	spawn_soul(self.position)
	queue_free()
	
func hit():
	is_hit = true
	enemy_hp -= 1
	animation.play("hit")
	check_status()
	await get_tree().create_timer(0.2).timeout
	is_hit = false

func spawn_soul(targetlocation):
	var soul = preload("res://Actors/soul.tscn")
	var soul_instance = soul.instantiate()
	soul_instance.position = targetlocation
	get_parent().add_child(soul_instance)
	
func _on_area_2d_area_entered(area):
	if(area.is_in_group("FromPlayer")):
		hit()
