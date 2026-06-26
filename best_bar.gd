extends Label

func _ready():
	var text= ""
	for i in range(5):
		var key= str(i)
		var best= GameData.best_scores.get(key,0)
		text+= "LEVEL "+ str(i+1)+ " - BEST: "+ str(best)+ "  "
	self.text= text.strip_edges()
