extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
var toggle_attack = false

func _physics_process(delta):
	if(!is_attacking):
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			if(velocity.y > 0):
				$AnimatedSprite2D.play("jump")
			else:
				$AnimatedSprite2D.play("fall")
		else:
			if(velocity.x == 0): 
				$AnimatedSprite2D.play("idle")
			else:
				$AnimatedSprite2D.play("run")

		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			if direction > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		check_attack()
		move_and_slide()

func check_attack():
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		$Area2D/CollisionShape2D.disabled = false
		$AnimatedSprite2D.play("attack")
		if($AnimatedSprite2D.flip_h):
			$Area2D/CollisionShape2D.position.x *= -1
			toggle_attack = true

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
	$Area2D/CollisionShape2D.disabled = true
	if toggle_attack:
		$Area2D/CollisionShape2D.position.x *= -1
		toggle_attack = false
