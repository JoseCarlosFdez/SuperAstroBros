extends CharacterBody2D

# Señal para avisar al Play.gd de que hemos tocado al jugador
signal player_hits_signal 

const SPEED = 100.0 # Velocidad más lenta para patrulla
const GRAVITY = 980.0

var direction = -1 # 1 = Derecha, -1 = Izquierda
var paused = false

@onready var sprite = $AnimatedSprite2D # Asegúrate de tener este nodo
@onready var floor_detector = $RayCast2D # EL NODO QUE AÑADISTE

func _ready():
	# Asegurarse de que el RayCast esté activado
	if floor_detector:
		floor_detector.enabled = true

func pause():
	paused = true
	$AnimatedSprite2D.stop()
	 # Opcional: detener animación

func _physics_process(delta: float) -> void:
	# Si está pausado (Game Over), no hacemos nada
	if ! paused:
		

	# 1. Aplicar Gravedad
		if not is_on_floor():
			velocity.y += GRAVITY * delta

		# 2. Lógica de Patrulla (Solo si está en el suelo)
		if is_on_floor():
			# Detectar Pared: Si chocamos contra un muro
			if is_on_wall():
				flip_direction()
				
			# Detectar Precipicio: Si el RayCast deja de tocar suelo
			# "is_colliding() == false" significa que hay un agujero delante
			if floor_detector and not floor_detector.is_colliding():
				flip_direction()

	# 3. Aplicar Movimiento
	velocity.x = direction * SPEED
	
	move_and_slide()
	
	# 4. Detectar colisión con el Jugador
	# Usamos get_slide_collision porque move_and_slide detecta choques
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.name == "Player" or collider.is_in_group("jugador"):
			emit_signal("player_hits_signal")
			pause()

func flip_direction():
	# Invertir dirección matemática (1 a -1 o viceversa)
	direction *= -1
	
	# --- CORRECCIÓN VISUAL ---
	# Si direction es 1 (Derecha), queremos que flip_h sea TRUE (si tu dibujo mira a la izq por defecto)
	# O viceversa. Simplemente invertimos la lógica que tenías antes.
	if direction > 0:
		sprite.flip_h = true  # Forzamos el volteo al ir a la derecha
	else:
		sprite.flip_h = false # Lo dejamos normal al ir a la izquierda
	
	# Invertir el detector de suelo (RayCast) para que mire al hueco correcto
	if floor_detector:
		floor_detector.position.x *= -1
