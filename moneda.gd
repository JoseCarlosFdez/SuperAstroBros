extends Area2D

# Señal personalizada para avisar que fue recogida
signal moneda_recogida

func _on_body_entered(body):
	# Verificamos si es el jugador (usando el grupo que creamos antes)
	if body.is_in_group("jugador"):
		# 1. Avisar al juego de que me recogieron
		moneda_recogida.emit()
		
		# 2. Efecto de sonido (opcional, si tienes un AudioStreamPlayer)
		# $AudioStreamPlayer.play()
		
		# 3. Desaparecer
		# Usamos call_deferred para evitar errores de física durante el choque
		queue_free()
