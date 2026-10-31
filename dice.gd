extends RigidBody3D
#states of the die yay
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
var spun_left:= false
var spun_right:= false

#load allat other scenes with onready

@onready var hud = get_node("/root/Main/CanvasLayer/AimLabel")
@onready var pts_label = get_node("/root/Main/CanvasLayer/PointsLabel")
@onready var win_screen = get_node("/root/Main/CanvasLayer/WinScreen")

"""
all states walkthrough, turning, pts accumulator, and ifthen statements :(
"""

	# freezes cube, reorients it and puts it in state WAITING where you "press space to start"
	
func _physics_process(delta):
	rotation.x = 0
	rotation.y = 0
	if state== State.WAITING:
		hud.text= "press space to start"
		freeze= true
		
	#just on the edge to launch
	
	elif state== State.IDLE:
		hud.text= "on the edge... (space to launch)"
		
	#ill explain okay okay
	
	elif state== State.AIR:
		
		#the spinning aspect with < and >
		
		if Input.is_action_pressed("ui_left"):
			apply_torque_impulse(Vector3(0, 0, 0.01))
			spun_left = true
		if Input.is_action_pressed("ui_right"):
			apply_torque_impulse(Vector3(0, 0, -0.01))
			spun_right = true
			
		#spin usage for spec goals
		
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			if spin_timer < 1.0:
				delayed_spin = false #lvl 4 failed
			used_spin = true #lvl 2 failed
			spin_timer += delta
			
		hud.text= "spin it(arrow keys < and >)!"
		airtime+= delta #time in air
		
		#find all rotations to count the flips
		
		var rot_diff= abs(rotation.z - finalrotation)
		rot_total+= rot_diff
		finalrotation= rotation.z #update it!
		flips= int(rot_total / (PI * 2)) #full rotation is a flip guys
		
		pts_label.text= str(int(airtime * 100) + (flips * 100)) + " pts"
		
		#check if touching lander & also if almost fully stopped
		if touching and linear_velocity.length() < 1.2 and angular_velocity.length() < 1.2:
			var tilt = abs(rotation.z)
			
			#good landing if its flat (near 0) or upside down (near PI)
			#need to fix this so its ALL FOUR SIDES
			
			if tilt < 0.25 or abs(tilt - PI) < 0.25 or abs(tilt - PI/2) < 0.25 or abs(tilt - 3*PI/2) < 0.25:
				state = State.LANDED
				var lm = get_node("/root/Main/LevelMan")
				points = int(airtime * 100) + (flips * 100)
				#save as the best scr if it is
				GameData.best_scores[str(lm.lvl_index)]= max(points,GameData.best_scores.get(str(lm.lvl_index),0))
				pts_label.text = str(points) + " pts"
				#send allat goal traccing to scrmngr
				var one_dir = (spun_left and not spun_right) or (spun_right and not spun_left)
				ScrMngr.finish_lvl(lm.lvl_index, points, flips, used_spin, cleared_checkpoint, delayed_spin, triple_flip, one_dir)
				win_screen.visible= true
				win_screen.show_goals(lm.lvl_index)
			else:
				#if bad angle (not lfat) reload lvl
				state = State.LANDED
				hud.text = "FAIL"
				get_node("/root/Main/LevelMan").loadlvl(get_node("/root/Main/LevelMan").lvl_index)
		elif state == State.LANDED:
			#when the dice land no movement so no buggy stuff
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
	# all of these resets at zero every jump
	airtime= 0.0
	flips= 0
	rot_total= 0.0
	cleared_checkpoint= false
	used_spin= false
	delayed_spin= true
	spin_timer= 0.0
	triple_flip= false
	finalrotation= rotation.z
	spun_left= false
	spun_right= false
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
