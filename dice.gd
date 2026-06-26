extends RigidBody3D
#states yay
enum State {IDLE, AIR, LANDED, WAITING}
var state= State.WAITING
var touching:= false

#pointspointspoints
	
var airtime:= 0.0
var flips:= 0
var finalrotation:= 0.0
var points:= 0
var rot_total:= 0.0
var used_spin:= false
var delayed_spin:= true
var spin_timer:= 0.0
var triple_flip:= false
var cleared_checkpoint:= false

@onready var hud = get_node("/root/Main/CanvasLayer/AimLabel")
@onready var pts_label = get_node("/root/Main/CanvasLayer/PointsLabel")
@onready var win_screen = get_node("/root/Main/CanvasLayer/WinScreen")
#all states walkthrough, turning, pt, and ifthen statements :(
func _physics_process(delta):
	rotation.x = 0
	rotation.y = 0
	if state== State.WAITING:
		hud.text= "press space to start"
		freeze= true
	elif state== State.IDLE:
		hud.text= "on the edge... (space to launch)"
	elif state== State.AIR:
		if Input.is_action_pressed("ui_left"):
			apply_torque_impulse(Vector3(0, 0, 0.01))
		if Input.is_action_pressed("ui_right"):
			apply_torque_impulse(Vector3(0, 0, -0.01))
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			if spin_timer < 1.0:
				delayed_spin = false
			used_spin = true
			spin_timer += delta
		hud.text= "spin it(arrow keys < and >)!"
		airtime+= delta
		var rot_diff= abs(rotation.z - finalrotation)
		rot_total+= rot_diff
		finalrotation= rotation.z
		flips= int(rot_total / (PI * 2))
		pts_label.text= str(int(airtime * 100) + (flips * 100)) + " pts"
		if touching and linear_velocity.length() < 1.2 and angular_velocity.length() < 1.2:
			var tilt = abs(rotation.z)
			if tilt < 0.45 or abs(tilt - PI) < 0.45:
				state = State.LANDED
				var lm = get_node("/root/Main/LevelMan")
				points = int(airtime * 100) + (flips * 100)
				GameData.best_scores[str(lm.lvl_index)]= max(points,GameData.best_scores.get(str(lm.lvl_index),0))
				pts_label.text = str(points) + " pts"
				ScrMngr.finish_lvl(lm.lvl_index, points, flips, used_spin, cleared_checkpoint, delayed_spin, triple_flip)
				win_screen.visible= true
				win_screen.show_goals(lm.lvl_index)
			else:
				state = State.LANDED
				hud.text = "FAIL"
				get_node("/root/Main/LevelMan").loadlvl(get_node("/root/Main/LevelMan").lvl_index)
		elif state == State.LANDED:
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
#for launch power and space=drop
func _input(event):
	if state== State.WAITING and Input.is_action_just_pressed("roll"):
		freeze= false
		state= State.IDLE
	elif state== State.IDLE and Input.is_action_just_pressed("roll") and linear_velocity.length() < 2.0:
		launch()
#lauch using trigs :)))
func launch():
	state= State.AIR
	# resets at zero every jump
	airtime= 0.0
	flips= 0
	rot_total= 0.0
	cleared_checkpoint= false
	used_spin= false
	delayed_spin= true
	spin_timer= 0.0
	triple_flip= false
	finalrotation= rotation.z
	var angle= rotation.z
	var dir= Vector3(sin(angle), cos(angle), 0)
	linear_velocity= dir * 7
	print("if you can see this ur going thru my code btw")
#is it touching lander or not
func _on_body_entered(body):
	var lm = get_node("/root/Main/LevelMan")
	if lm.current_level and body == lm.current_level.get_lander():
		touching = true

func _on_body_exited(body):
	var lm = get_node("/root/Main/LevelMan")
	if lm.current_level and body == lm.current_level.get_lander():
		touching = false
			
func reset():
	state = State.WAITING
	freeze = true
