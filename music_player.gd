extends AudioStreamPlayer
# safety ;)
func _ready():
	if not playing:
		play()
