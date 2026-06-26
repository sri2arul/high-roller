extends Camera3D

@export var target: Node3D
var angle := 0.0
var radius := 4.0
var height := 4.0

func _process(delta):
	angle += delta * 0.1
	global_position = target.global_position + Vector3(cos(angle) * radius, height, sin(angle) * radius)
	look_at(target.global_position, Vector3.UP)
