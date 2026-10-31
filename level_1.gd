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
	var wp = get_node_or_null("WorkerPass")
	if wp:
		wp.body_entered.connect(_on_worker_zone)
	
func _on_worker_zone(body):
	if body.is_in_group("dice"):
		body.cleared_checkpoint= true
