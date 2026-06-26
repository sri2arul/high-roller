extends Control

@onready var fullscreen_toggle = $Panel/FSTogglr
@onready var volume_slider = $Panel/VolSlider

func _ready():
	GlobalUI.visible= false
	fullscreen_toggle.button_pressed = SettingsData.fullscreen
	apply_fullscreen()
	volume_slider.value = SettingsData.music_volume
	MusicPlayer.volume_db = linear_to_db(SettingsData.music_volume)
	
	

func _on_fs_togglr_toggled(toggled_on):
	SettingsData.fullscreen = toggled_on
	apply_fullscreen()

func apply_fullscreen():
	if SettingsData.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func _on_vol_slider_value_changed(value):
	SettingsData.music_volume = value
	MusicPlayer.volume_db = linear_to_db(value)
	
