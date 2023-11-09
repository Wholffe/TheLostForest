extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
var toggle_attack = false
var can_jump = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $coyote_timer
@onready var jump_buffer: Timer = $jump_buffer

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_jump = true
		
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if !is_attacking:
			if direction > 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if(!is_attacking):
		update_animation()
	
	if !jump_buffer.is_stopped() and (is_on_floor() or !coyote_timer.is_stopped() and can_jump):
		jump()

	if Input.is_action_just_pressed("jump"):
		jump_buffer.start()
		
	var was_on_floor = is_on_floor()
	
	check_attack()
	move_and_slide()
	
	if was_on_floor and !is_on_floor() and coyote_timer.is_stopped():
		coyote_timer.start()

func jump():
	velocity.y = JUMP_VELOCITY
	can_jump = false
	
func update_animation():
	if not is_on_floor():
		if(velocity.y > 0):
			animation.play("fall")
		else:
			animation.play("jump")
	else:
		if(velocity.x == 0): 
			animation.play("idle")
		else:
			animation.play("run")
	
func check_attack():
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		$Area2D/CollisionShape2D.disabled = false
		animation.play("attack")
		if(sprite.flip_h):
			$Area2D/CollisionShape2D.position.x *= -1
			toggle_attack = true

func _on_animation_player_animation_finished(anim_name):
	is_attacking = false
	$Area2D/CollisionShape2D.disabled = true
	if toggle_attack:
		$Area2D/CollisionShape2D.position.x *= -1
		toggle_attack = false
