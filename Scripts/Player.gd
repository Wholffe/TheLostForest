extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
var toggle_attack = false
var can_jump = false
var direction: Vector2 = Vector2.ZERO
var dir = 1

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

@onready var coyote_timer: Timer = $coyote_timer
@onready var jump_buffer: Timer = $jump_buffer

func _ready():
	animation_tree.active = true
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_jump = true
		
	direction = Input.get_vector("left","right","up","down")
	if direction.x != 0:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if !jump_buffer.is_stopped() and (is_on_floor() or !coyote_timer.is_stopped() and can_jump):
		jump()
	if Input.is_action_just_pressed("jump"):
		jump_buffer.start()
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	update_facing_direction()	
	update_animation()
	
	if was_on_floor and !is_on_floor() and coyote_timer.is_stopped():
		coyote_timer.start()

func jump():
	velocity.y = JUMP_VELOCITY
	can_jump = false
	
func update_animation():
	animation_tree.set("parameters/move/blend_position",direction.x)
	
func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
