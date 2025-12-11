extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_music_boton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		$AudioStreamPlayer.stop()
		$MusicButtonOff.show()
		$MusicButton.hide()

func _on_music_boton_off_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		$AudioStreamPlayer.play()
		$MusicButtonOff.hide()
		$MusicButton.show()

func _on_play_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		get_tree().change_scene_to_file("res://IntroNivel1.tscn")
