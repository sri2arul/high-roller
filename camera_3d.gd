extends Camera3D

@export var target: Node3D

# called every frame
func _process(delta):
	if !target: return #do nothing if noe target
	
	#snap cam to offset posintion relative to target
	global_position.x= lerp(global_position.x, target.global_position.x- 7, 1)
	global_position.y= lerp(global_position.y, target.global_position.y+ 11, 1)
	global_position.z= lerp(global_position.z, target.global_position.z+ 7, 1)
	
	#explanitory always look at dem target
	look_at(target.global_position, Vector3.UP)
