extends Button

func _pressed():
	get_node("/root/Main/LevelMan").loadlvl(get_node("/root/Main/LevelMan").lvl_index)
