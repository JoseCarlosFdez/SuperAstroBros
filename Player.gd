extends CharacterBody2D

const SPEED = 500
const JUMP_VELOCITY = -650.0 
const GRAVITY = 1000.0
var paused = false

func die():
	print("ESTOY MUERTO") # Si ves esto, funciona.
	paused = true
	velocity = Vector2.ZERO # Freno de mano
	$AnimatedSprite2D.stop() 

func _physics_process(delta):
	# 1. Gravedad (Siempre)
	if not is_on_floor():
		velocity.y += GRAVITY * delta 

	# 2. Controles (SOLO SI NO ESTÁ PAUSADO)
	if not paused:  # <--- SI ESTO FALTA, TE SEGUIRÁS MOVIENDO
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY 
		
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			# Manejo básico de animación y flip
			if direction > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("Astro_moving")
		else:
			velocity.x = 0
			$AnimatedSprite2D.play("Astro_idle")
			
	# 3. Si está muerto (paused = true)
	else:
		velocity.x = 0 # Asegura que se detenga horizontalmente
		
	move_and_slide()
