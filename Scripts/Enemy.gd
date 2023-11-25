extends CharacterBody2D

const JUMP_VELOCITY = -400.0
@export var speed = 50.0
@export var enemy_hp = 3
@export var damage = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
var direction = 1
var is_hit = false
var is_attacking = false
var player_dir
var knockback = false 
var knockback_dir = 1

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	check_status()

func _process(delta):
	player_dir = get_parent().get_node("Player").dir
		
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	update_animation()
	if !(is_dead):
		if knockback:
			animation.play("hit")
			velocity.y = -100
			velocity.x = 100 * knockback_dir
			knockback = false
		if is_on_wall() and !is_attacking:
			direction *= -1
			animation.flip_h = !animation.flip_h
		if !is_attacking:
			animation.play("move")
		velocity.x = speed * direction
		move_and_slide()
	else:
		$CollisionShape2D.disabled = true
		if !$VisibleOnScreenNotifier2D.is_on_screen():
			queue_free()

func check_status():
	if(enemy_hp<=0):
		kill_enemy()
	if !is_dead:
		if is_attacking:
			attack()
		else:
			pass

func kill_enemy():
	is_dead = true
	animation.stop()
	velocity.x = 0
	animation.play("death")
	$Area2D/CollisionShape2D.disabled = true
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(1.5).timeout
	$GPUParticles2D.emitting = false
	spawn_soul(self.position)
	
func hit():
	is_hit = true
	enemy_hp -= 1
	animation.play("hit")
	check_status()
	knockback_dir = player_dir
	knockback = true
	await get_tree().create_timer(0.2).timeout
	is_hit = false
	check_status()

func spawn_soul(targetlocation):
	var soul = preload("res://Actors/soul.tscn")
	var soul_instance = soul.instantiate()
	soul_instance.position = targetlocation
	get_parent().add_child(soul_instance)

func attack():
	speed = 0
	animation.pause()
	animation.play("attack")
	await get_tree().create_timer(0.5).timeout
	if !is_attacking or is_dead or is_hit:
		return
	Globals.player_damage(damage)
	check_status()

func turn_to_player():
	var collider = $RayCast2DRight.get_collider()
	if collider:
		direction = 1
		animation.flip_h = false
	else:
		direction = -1
		animation.flip_h = true

func update_animation():
	if direction > 1:
		animation.flip_h = false
	elif direction < -1:
		animation.flip_h = true

func _on_area_2d_area_entered(area):
	if(area.is_in_group("FromPlayer") and !is_dead):
		hit()
		
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and !is_dead:
		$AttackArea/CollisionShape2D.disabled = false
		is_attacking = true
		turn_to_player()
		check_status()

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player") and !is_dead:
		speed = 50
		is_attacking = false
		$AttackArea/CollisionShape2D.disabled = true
		check_status()
