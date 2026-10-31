extends Node3D

#loads bestlbl
@onready var best_lbl= $CanvasLayer/BestLbl


func _ready():
	GlobalUI.visible= true
	#conecct events for all 10 lvls
	for i in range(5):
		var btn= get_node("CanvasLayer/Page 1/Level"+ str(i+1)+ "Btn")
		btn.mouse_entered.connect(touche.bind(i))
		btn.mouse_exited.connect(untouche)
	
	for i in range(5, 10):
		var btn= get_node("CanvasLayer/Page 2/Level"+ str(i+1)+ "Btn")
		btn.mouse_entered.connect(touche.bind(i))
		btn.mouse_exited.connect(untouche)
		
	var w = get_viewport().get_visible_rect().size.x
	$"CanvasLayer/Page 2".position.x = w			
	$"CanvasLayer/Page 2".visible = true
	$"CanvasLayer/LeftBtn".pressed.connect(slide_to.bind(0))
	$"CanvasLayer/RightBtn".pressed.connect(slide_to.bind(1))
	
#shows best core if hover
func touche(lvl_index):
	best_lbl.show_best(lvl_index)
	
func untouche():
	#small delay so no flicker effect i hope (it still does it smtnites so fix?)
	await get_tree().create_timer(0.5).timeout  
	best_lbl.hide_best()
	
var page =0
func slide_to(p):
	if p== page:
		return 
	page =p
	var w=get_viewport().get_visible_rect().size.x
	var tween_slide = create_tween().set_parallel()
	tween_slide.tween_property($"CanvasLayer/Page 1", "position:x", -w*p, 0.4)
	tween_slide.tween_property($"CanvasLayer/Page 2", "position:x", w-w*p, 0.4)
