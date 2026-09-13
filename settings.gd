extends Control

#grabers UI
@onready var fullscreen_toggle = $Panel/FSTogglr
@onready var volume_slider = $Panel/VolSlider

func _ready():
	GlobalUI.visible= false #coin hide
	#set toggle and slider to match saved setings
	fullscreen_toggle.button_pressed = SettingsData.fullscreen
	apply_fullscreen()
	volume_slider.value = SettingsData.music_volume
	MusicPlayer.volume_db = linear_to_db(SettingsData.music_volume)
	
	
#apply fullscreen when toggled
func _on_fs_togglr_toggled(toggled_on):
	SettingsData.fullscreen = toggled_on
	apply_fullscreen()

#between fullscr and windowed mode
func apply_fullscreen():
	if SettingsData.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
#save vol and turn it into decibles in music player
func _on_vol_slider_value_changed(value):
	SettingsData.music_volume = value
	MusicPlayer.volume_db = linear_to_db(value)
	
