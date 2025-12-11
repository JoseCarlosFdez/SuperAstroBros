extends CharacterBody2D
signal player_hits_signal

const GRAVITY = 8.0
var motion = Vector2(5.0, 0.0)
const BOUNCE_VEL = -10.0
var paused = false

func _ready():
	pass

func pause():
	paused = true

func _physics_process(delta):
	if !paused:
		# Límites del mapa (Seguridad extra)
		if position.x < 0 or position.x > 1920:
			motion.x = -motion.x

		motion.y += delta * GRAVITY
		
		# Movemos y guardamos la colisión
		var collision = move_and_collide(motion)
		
		if (collision != null):
			var collider = collision.get_collider()
			
			# --- CASO 1: TOCAR AL JUGADOR ---
			if "Player" == collider.name:
				emit_signal("player_hits_signal")
				motion = Vector2.ZERO # Poner la velocidad a 0 visualmente
				pause() # Activar la variable paused para que deje de procesar física
			
			# --- CASO 2: REBOTAR CON TODO LO DEMÁS ---
			else:
				var normal = collision.get_normal()
				
				# Si el golpe es en el Suelo (Normal apunta arriba) -> Salto constante
				if normal.y < 0:
					motion.y = BOUNCE_VEL
				
				# Si el golpe es en una Pared (Normal horizontal) -> Invertir dirección X
				elif normal.x != 0:
					motion.x = -motion.x
				
				# Si el golpe es en el Techo (Normal apunta abajo) -> Rebotar hacia abajo
				elif normal.y > 0:
					motion.y = -motion.y # O simplemente 0 si quieres que caiga seco



func _on_area_2d_body_entered(body):
	# Solo entramos aquí si el cuerpo es el JUGADOR
	if body.is_in_group("jugador"):
		print("¡TE PILLÉ! Matando al jugador...")
		body.die()
