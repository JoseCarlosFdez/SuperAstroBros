extends Node2D

func _ready() -> void:
	# 1. Esperar 3 segundos para que lean el texto
	await get_tree().create_timer(3.0).timeout
	
	# 2. Cargar el siguiente nivel
	# Como ya actualizamos Global.nivel_actual a 2 en el botón anterior,
	# sabemos que toca cargar el nivel 2.
	if Global.nivel_actual == 2:
		get_tree().change_scene_to_file("res://play2.tscn")
