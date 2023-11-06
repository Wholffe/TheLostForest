extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var enemy_hp = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if(!is_dead):
		move_and_slide()

func check_status():
	if(enemy_hp<=0):
		kill_enemy()
	else:
		$AnimatedSprite2D.play("idle")

func kill_enemy():
	is_dead = true
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(1).timeout
	queue_free()
	
func hit():
	enemy_hp -= 1
	$AnimatedSprite2D.play("hit")
	await get_tree().create_timer(0.2).timeout
	check_status()

func _on_area_2d_area_entered(area):
	if(area.is_in_group("FromPlayer")):
		hit()
