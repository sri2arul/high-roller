extends Button

func _pressed():
	GameData.selected_level = 3
	get_tree().change_scene_to_file("res://main.tscn")
