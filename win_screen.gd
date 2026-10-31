extends ColorRect

#snatch all uiiui
@onready var bronze_lbl= $BronzeLbl
@onready var silver_lbl= $SilverLbl
@onready var gold_lbl= $GoldLbl
@onready var diamond_lbl= $DiamondLbl
@onready var bronze_coin= $BronzeCoin
@onready var silver_coin= $SilverCoin
@onready var gold_coin= $GoldCoin
@onready var diamond_coin= $DiamondCoin
@onready var best_lbl= $BestLbl
@onready var spec_lbl= $SpecLbl
@onready var spec_coin= $SpecCoin

func show_goals(lvl_index):
	var goals= ScrMngr.point_goals[lvl_index]
	var key= str(lvl_index)
	#the names for specgoals
	var spec_names= ["flip","no_spin","bottle_pass","delayed_spin","triple_flip","worker_pass","flip","one_dir","double_flip","quad_flip"]
	#display texts
	var spec_txts= ["SPECIAL: LAND A FLIP","SPECIAL: LAND WITHOUT MANUALLY SPINNING","SPECAL: LAND PAST THE BOTTLE","SPECIAL: DELAY SPIN by a second","SPECIAL: DO A TRIPLE FLIP", "SPECIAL: LAND IN FRONT OF THE WORKER", "SPECIAL: LAND A FLIP", "SPECIAL: SPIN IN ONLY ONE DIRECTION", "SPECIAL: LAND A DOUBLE FLIP", "SPECIAL: LAND FOUR + FLIPS",]
	#goal id from spec goal
	var spec_id= str(lvl_index)+"_"+spec_names[lvl_index]
	#updates/shows best lvl 
	best_lbl.text= "BEST SCORE: "+ str(GameData.best_scores.get(key,0))
	#pt goals lbls 
	bronze_lbl.text= "BRONZE - "+ str(goals["bronze"])
	silver_lbl.text= "SILVER - "+ str(goals["silver"])
	gold_lbl.text= "GOLD - "+ str(goals["gold"])
	diamond_lbl.text= "DIAMOND - "+ str(goals["diamond"])
	
	#grey out clamied goals and hide coin if claimed
	set_goal_color(bronze_lbl, bronze_coin, lvl_index, "bronze")
	set_goal_color(silver_lbl, silver_coin, lvl_index, "silver")
	set_goal_color(gold_lbl, gold_coin, lvl_index, "gold")
	set_goal_color(diamond_lbl, diamond_coin, lvl_index, "diamond")

	#spec goal text shower
	spec_lbl.text= spec_txts[lvl_index]
	#grey out spec goal and hide coin if claimed
	if GameData.claimed_goals.has(spec_id):
		spec_lbl.modulate= Color(0.4, 0.4, 0.4, 1)
		spec_coin.visible= false
	else:
		spec_lbl.modulate= Color(1,1,1,1)
		spec_coin.visible= true
func set_goal_color(label, coin, lvl_index, goal_name):
	var goal_id= str(lvl_index)+ "_"+ goal_name
	
	#green claimed, white unclained
	if GameData.claimed_goals.has(goal_id):
		label.modulate= Color(0.221, 1.0, 0.209, 1.0)
		coin.visible= false
	else:
		label.modulate= Color(1,1,1,1)
		coin.visible= true
