extends Node3D

@export var ground: Node3D
@export var lander: Node3D
@export var target: Node3D

func get_ground():
	return ground

func get_lander():
	return lander

func _ready():
	GlobalUI.visible= true
	$BirdPass.body_entered.connect(when_bird_passed)
	
func when_bird_passed(body):
	if body.is_in_group("dice"):
		body.cleared_checkpoint= true
