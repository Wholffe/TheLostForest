extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
var toggle_attack = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer

func _physics_process(delta):
	if(!is_attacking):
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			if(velocity.y > 0):
				animation.play("fall")
			else:
				animation.play("jump")
		else:
			if(velocity.x == 0): 
				animation.play("idle")
			else:
				animation.play("run")

		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			if direction > 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		move_and_slide()
		check_attack()

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
