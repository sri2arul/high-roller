extends Button

func _pressed():
	var lm = get_node("/root/Main/LevelMan")
	lm.lvl_index -= 1

	if lm.lvl_index < 0:
		lm.lvl_index = 0

	lm.loadlvl(lm.lvl_index)
	get_node("/root/Main/CanvasLayer/WinScreen").visible = false
