extends Label

func show_best(lvl_index):
	visible= true
	
	var best= GameData.best_scores.get(str(lvl_index),0)
	var goals= ScrMngr.point_goals[lvl_index]
	
	$BronzeScore.text= str(goals["bronze"])
	$SilverScore.text= str(goals["silver"])
	$GoldScore.text= str(goals["gold"])
	$DiamondScore.text= str(goals["diamond"])
	
	$BronzeRect.visible= best>= goals["bronze"]
	$BronzeScore.visible= best>= goals["bronze"]
	
	$SilverRect.visible= best>= goals["silver"]
	$SilverScore.visible= best>= goals["silver"]
	
	$GoldRect.visible= best>= goals["gold"]
	$GoldScore.visible= best>= goals["gold"]
	
	$DiamondRect.visible= best>= goals["diamond"]
	$DiamondScore.visible= best>= goals["diamond"]
	
	text= "BEST: "+ str(GameData.best_scores.get(str(lvl_index),0))
	
func hide_best():
	visible= false
