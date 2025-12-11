extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_siguiente_nivel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		
		# IMPORTANTE: Quitamos la pausa antes de cambiar de escena
		get_tree().paused = false 
		
		# CASO 1: Estamos en el Nivel 1 y vamos al 2
		if Global.nivel_actual == 1:
			Global.nivel_actual = 2 
			get_tree().change_scene_to_file("res://pantalla_de_carga_2.tscn")
			
		# CASO 2: Estamos en el Nivel 2 (Fin del juego)
		elif Global.nivel_actual == 2:
			print("¡Juego completado!")
			get_tree().change_scene_to_file("res://main_menu.tscn")
