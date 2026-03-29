extends Area2D

# Variable para saber si el jugador está dentro del rango
var jugador_en_rango = false

func _ready():
	# Conectamos las señales por código para estar seguros
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta):
	# Si está en rango y presiona la tecla E (debes configurarla en Input Map)
	if jugador_en_rango and Input.is_action_just_pressed("interact"):
		abrir_dialogo()

func abrir_dialogo():
	var jugador = get_tree().get_first_node_in_group("Jugador")
	if jugador and jugador.has_method("set_physics_process"):
		jugador.set_physics_process(false) 
	
	# 1. Cargamos la escena de TU Balloon
	var balloon_scene = load("res://Dialogues/balloon.tscn")
	var balloon = balloon_scene.instantiate()
	
	# 2. Lo añadimos a la pantalla (al árbol de escenas)
	get_tree().current_scene.add_child(balloon)
	
	# 3. Cargamos el recurso de diálogo
	var dialogue_resource = load("res://Dialogues/test.dialogue")
	
	# 4. Usamos la función 'start' que ya viene en tu script de Balloon
	# start(recurso, "título")
	balloon.start(dialogue_resource, "estatua_antigua")
	
	# 5. Esperar a que el diálogo se cierre
	await DialogueManager.dialogue_ended
	
	if jugador and jugador.has_method("set_physics_process"):
		jugador.set_physics_process(true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_en_rango = true
		# Opcional: Mostrar un iconito de "Presiona E" sobre la estatua
		print("Presiona E para leer")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_en_rango = false
