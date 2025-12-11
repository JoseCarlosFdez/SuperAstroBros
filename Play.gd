extends Node2D

# Referencia a la escena de la moneda para poder crear copias
var escena_moneda = preload("res://moneda.tscn") 

# Variables de juego
var monedas_totales = 0 
var monedas_restantes = 0

# Límites donde pueden aparecer las monedas (Ajusta esto a tu mapa)
const LIMITE_IZQUIERDA = 50
const LIMITE_DERECHA = 1850
const LIMITE_ARRIBA = 200
const LIMITE_ABAJO = 900

func _ready() -> void:
	# Conectamos las señales de tus 3 enemigos
	# Asegúrate de que los nodos en la escena se llamen así
	
	$Enemigo.connect("player_hits_signal", _on_game_over)
	$Enemigo2.connect("player_hits_signal", _on_game_over)
	$Enemigo3.connect("player_hits_signal", _on_game_over)
	if has_node("Enemigo4"):
		$Enemigo4.connect("player_hits_signal", _on_game_over)
	# 1. LEEMOS EL OBJETIVO DEL GLOBAL
	monedas_totales = Global.monedas_objetivo
	monedas_restantes = monedas_totales
	
	actualizar_contador()
	generar_monedas()

func _on_game_over():
	print("¡GAME OVER! Deteniendo todo...")
	
	# 1. Detener a TODOS los enemigos
	# (Todos tus scripts de enemigo deben tener la función "pause")
	$Enemigo.pause() 
	$Enemigo2.pause()
	$Enemigo3.pause()
	
	if has_node("Enemigo4"): $Enemigo4.pause()
	
	
	# 2. Matar al jugador (Animación y freno)
	$Player.die()
	
	# 3. Esperar un poco y cambiar de escena
	# Creamos un temporizador de 1 segundo para ver la muerte
	await get_tree().create_timer(1.0).timeout
	
	# Cambiamos a la escena de Game Over
	get_tree().change_scene_to_file("res://derrota.tscn")
	
func generar_monedas():
	for i in range(monedas_totales):
		# Crear una nueva moneda
		var nueva_moneda = escena_moneda.instantiate()
		
		# Calcular posición aleatoria
		var x_random = randf_range(LIMITE_IZQUIERDA, LIMITE_DERECHA)
		var y_random = randf_range(LIMITE_ARRIBA, LIMITE_ABAJO)
		nueva_moneda.position = Vector2(x_random, y_random)
		
		# Conectar la señal de la moneda a nuestra función de contar
		nueva_moneda.moneda_recogida.connect(_on_moneda_recogida)
		
		# Añadirla al juego
		add_child(nueva_moneda)

func _on_moneda_recogida():
	monedas_restantes -= 1
	actualizar_contador()
	
	# Verificar si ganamos
	if monedas_restantes <= 0:
		ganar_juego()

func actualizar_contador():
	# Accedemos al Label (Asegúrate de la ruta correcta)
	$CanvasLayer/ContadorLabel.text = "Faltan: " + str(monedas_restantes)

func ganar_juego():
	print("¡HAS GANADO!")
	Global.monedas_objetivo += 10 # Ahora pedirá 10 monedas más
	# Detenemos el juego o cambiamos de escena
	get_tree().paused = true
	get_tree().change_scene_to_file("res://victoria.tscn")
