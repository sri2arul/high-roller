extends Node3D
var current_level = null
var lvl_index := 0

#all lvl scene pathss in order
var levels = ["res://world 1//level1.tscn", "res://world 1//level2.tscn", "res://world 1//level3.tscn", "res://world 1//level4.tscn", "res://world 1//level5.tscn", "res://world 2//level6.tscn", "res://world 2//level7.tscn", "res://world 2//level8.tscn", "res://world 2//level9.tscn", "res://world 2//level10.tscn"]

#dice sie
@export var d: RigidBody3D

#where the dice spawns so it doesnt float over or cramp up 

var spawn_offsets=[
	Vector3(6.05, 1, 0),
	Vector3(0.5, 1, 0),
	Vector3(3.5, 1, 12),
	Vector3(3.7, 1, 0),
	Vector3(0.7, 1, 0),
	Vector3(0, 0.5, 2),
	Vector3(0.7, 1, 0),
	Vector3(0.7, 1, 0),
	Vector3(0.7, 1, 0),
	Vector3(0.7, 1, 0)
	]
var loading := false
func _ready():
	#guard that makey so run if act levelman node
	if get_node_or_null("/root/Main/LevelMan") != self:
		return
	print("READY CALLED")
	loadlvl(GameData.selected_level)
	
func loadlvl(idx):
	print("loadlvl called: ", idx, " loading: ", loading)
	if loading:
		return
	loading = true
	lvl_index = idx
	
	#removings old level if there was one
	if current_level:
		current_level.queue_free()
	current_level = load(levels[idx]).instantiate()
	
	#spwan the new level
	if current_level == null:
		push_error("Failed to load: " + levels[idx])
		loading = false
		return
		
	add_child(current_level)
	print("level type: ", current_level.get_class())
	print("has get_ground: ", current_level.has_method("get_ground"))
	
	var ground = current_level.get_ground()
	var lander = current_level.get_lander()
	
	if not ground:
		push_error("LevelMan: Ground node not found in loaded level: %s" % levels[idx])
		loading = false
		return
	if not lander:
		push_warning("LevelMan: Lander node not found in loaded level: %s" % levels[idx])
		
	#disabl targ monitoring when setup so no prefire
	var tgt = current_level.get_node_or_null("Target")
	if tgt:
		tgt.monitoring = false
		
	# position the dice safely
	d.freeze = false
	await get_tree().physics_frame
	d.global_position = ground.global_position + spawn_offsets[idx]
	d.linear_velocity = Vector3.ZERO
	d.angular_velocity = Vector3.ZERO
	d.rotation = Vector3.ZERO 
	d.touching = false
	transform.basis = Basis.IDENTITY
	d.reset()
	
	get_node("/root/Main/CanvasLayer/WinScreen").visible = false
	call_deferred("_enable_target_monitoring", tgt)
	loading = false
	
func next():
	lvl_index += 1
	if lvl_index >= levels.size():
		print("GAME COMPLETE")
		return
	loadlvl(lvl_index)
	
func _enable_target_monitoring(tgt):
	if tgt and is_instance_valid(tgt):
		tgt.monitoring = true
