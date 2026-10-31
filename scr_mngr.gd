extends Node

'''
this manages scores from regular goals and special goals & more for each level and converts them into coins.
'''

	# the point goals for each level / the BSGDs for each level
	
var point_goals = [
	{"bronze": 150, "silver": 250, "gold": 350, "diamond": 400},
	{"bronze": 200, "silver": 300, "gold": 450, "diamond": 500},
	{"bronze": 300, "silver": 450, "gold": 600, "diamond": 750},
	{"bronze": 400, "silver": 550, "gold": 700, "diamond": 800},
	{"bronze": 450, "silver": 650, "gold": 850, "diamond": 1000},
	{"bronze": 150, "silver": 250, "gold": 350, "diamond": 400},
	{"bronze": 200, "silver": 300, "gold": 450, "diamond": 500},
	{"bronze": 300, "silver": 450, "gold": 600, "diamond": 750},
	{"bronze": 400, "silver": 550, "gold": 700, "diamond": 800},
	{"bronze": 450, "silver": 650, "gold": 850, "diamond": 1000},
]

func finish_lvl(lvl_index, points, flips, used_spin, cleared_checkpoint, delayed_spin, triple_flip, one_dir):
	GameData.total_points+= points
	
	var goals = point_goals[lvl_index]

	check_point_goal(lvl_index, "bronze", points, goals["bronze"], 5)
	check_point_goal(lvl_index, "silver", points, goals["silver"], 10)
	check_point_goal(lvl_index, "gold", points, goals["gold"], 15)
	check_point_goal(lvl_index, "diamond", points, goals["diamond"], 25)
			
	# uncomment these when the time comes - done 
	# these are if statements where if the conditional is proven true, it awards the special acheivment.
	
	if lvl_index == 0 and flips>= 1:
		award_special(lvl_index, "flip", 10)
	
	if lvl_index == 1 and used_spin== false:
		award_special(lvl_index, "no_spin", 10)
		
	if lvl_index == 2 and cleared_checkpoint== true:
		award_special(lvl_index, "bottle_pass", 10)
		
	if lvl_index == 3 and delayed_spin== true:
		award_special(lvl_index, "delayed_spin", 10)
	
	if lvl_index == 4 and flips>= 3:
		award_special(lvl_index, "triple_flip", 10) 
		
	if lvl_index == 5 and cleared_checkpoint == true:
		award_special(lvl_index, "worker_pass", 10)

	if lvl_index == 6 and flips >= 1:
		award_special(lvl_index, "flip", 10)

	if lvl_index == 7 and one_dir == true:
		award_special(lvl_index, "one_dir", 10)

	if lvl_index == 8 and flips >= 2:
		award_special(lvl_index, "double_flip", 10)
	
	if lvl_index == 9 and flips>= 4:
		award_special(lvl_index, "quad_flip", 10) 
		
	# 
	
func check_point_goal(lvl_index, goal_name, points, required_points, coins):
	var goal_id= str(lvl_index)+ "_"+ goal_name
	
	if points >= required_points and not GameData.claimed_goals.has(goal_id):
		GameData.coins+= coins
		GameData.claimed_goals[goal_id]= true
		
func award_special(lvl_index,goal_name, coins):
	var goal_id= str(lvl_index)+ "_"+ goal_name
	
	if not GameData.claimed_goals.has(goal_id):
		GameData.coins+= coins
		GameData.claimed_goals[goal_id]= true
		
