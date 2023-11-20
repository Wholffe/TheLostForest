extends State
class_name AttackState

@onready var player: Player = $"../.."

func enter_state():
	player.is_attacking = true
	if(player.sprite.flip_h):
		$"../../Area2D/CollisionShape2D".position.x *= -1
		player.toggle_attack = true
	$"../../Area2D/CollisionShape2D".disabled = false

func exit_state():
	$"../../Area2D/CollisionShape2D".disabled = true
	if player.toggle_attack:
		$"../../Area2D/CollisionShape2D".position.x *= -1
		player.toggle_attack = false
	
func physics_update(delta):
	await get_tree().create_timer(2).timeout
	player.is_attacking = false 
	if !player.is_attacking:
		Transitioned.emit(self,"GroundState")
