extends Node3D

@onready var best_lbl= $CanvasLayer/BestLbl

func _ready():
	GlobalUI.visible= true
	for i in range(5):
		var btn= get_node("CanvasLayer/Level"+ str(i+1)+ "Btn")
		
		btn.mouse_entered.connect(touche.bind(i))
		btn.mouse_exited.connect(untouche)
		
func touche(lvl_index):
	best_lbl.show_best(lvl_index)
	
func untouche():
	await get_tree().create_timer(0.5).timeout  
	best_lbl.hide_best()
	
 
