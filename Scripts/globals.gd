extends Node

var hp: int = 5
var mana: int = 0

func _ready():
	pass

func _process(delta):
	pass

func add_mana():
	mana += 1
	print(mana)

func player_damage(amount:int):
	hp -= amount
