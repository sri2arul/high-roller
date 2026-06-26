extends CanvasLayer

@onready var coin_lbl= $CoinLbl

func _process(delta):
	coin_lbl.text= str(GameData.coins)
