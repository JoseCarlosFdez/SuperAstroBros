extends Node2D

# Esta es la ruta a tu escena de juego real
const ESCENA_JUEGO = "res://play1.tscn" 

func _ready() -> void:
	# 1. Esperar 3 segundos
	await get_tree().create_timer(3.0).timeout
	
	# 2. Cambiar a la escena de juego
	get_tree().change_scene_to_file(ESCENA_JUEGO)
