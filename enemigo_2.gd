extends CharacterBody2D
signal player_hits_signal

# --- CONFIGURACIÓN DE MOVIMIENTO ---
@export var speed_x: float = 300.0      
@export var wave_height: float = 100.0  
@export var wave_speed: float = 4.0     

# --- LÍMITES FIJOS DEL MAPA ---
const LIMIT_LEFT = 100
const LIMIT_RIGHT = 1800

var time_passed = 0.0
var paused = false

# Referencia al Sprite para voltearlo (Ajusta el nombre si el tuyo es diferente)
@onready var sprite = $AnimatedSprite2D 

func _ready():
	velocity.x = speed_x
	update_facing_direction() # Orientar correctamente al inicio

func pause():
	paused = true
	$AnimatedSprite2D.stop()
	
func unpause():
	paused = false

func _physics_process(delta):
	if !paused:
		
		# --- 1. COMPROBAR LÍMITES ---
		
		# Si llega al límite DERECHO -> Ir a la IZQUIERDA
		if position.x >= LIMIT_RIGHT:
			velocity.x = -abs(speed_x)
			
		# Si llega al límite IZQUIERDO -> Ir a la DERECHA
		elif position.x <= LIMIT_LEFT:
			velocity.x = abs(speed_x)
			
		# Rebote en PAREDES físicas
		if is_on_wall():
			velocity.x = -velocity.x

		# --- 2. ACTUALIZAR DIRECCIÓN VISUAL (GIRAR) ---
		update_facing_direction()

		# --- 3. MOVIMIENTO VERTICAL ---
		time_passed += delta
		velocity.y = sin(time_passed * wave_speed) * wave_height
		
		# --- 4. MOVER ---
		move_and_slide()
		
		# --- 5. COLISIONES ---
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider != null and "Player" == collider.name:
				emit_signal("player_hits_signal")
				velocity = Vector2.ZERO
				pause()
				break

# Función auxiliar para gestionar el giro
func update_facing_direction():
	if velocity.x > 0:
		# Si va a la derecha, NO voltear (asumiendo que el dibujo original mira a la derecha)
		sprite.flip_h = true
	elif velocity.x < 0:
		# Si va a la izquierda, voltear horizontalmente
		sprite.flip_h = false


func _on_area_2d_body_entered(body):
	# "body" es el objeto que acaba de chocar con el pincho.
	
	# Opción A (Más segura): Preguntar si el cuerpo tiene la función "die"
	if body.has_method("die"):
		print("¡Impacto con el jugador!")
		body.die() # <--- AQUÍ ES DONDE SE EJECUTA TU FUNCIÓN
		
	# Opción B (Por nombre): Solo si tu jugador se llama exactamente así
	# if body.name == "CharacterBody2D":
	# 	body.die()
