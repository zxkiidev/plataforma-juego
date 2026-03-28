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
	# Bloqueamos al jugador (puedes ajustar el nombre de la función según lo que use tu amigo)
	var jugador = get_tree().get_first_node_in_group("Jugador")
	if jugador.has_method("set_physics_process"):
		jugador.set_physics_process(false) 
	
	# LANZAR EL DIÁLOGO
	# "res://dialogos/historia.dialogue" es la ruta de tu archivo
	# "estatua_antigua" es el nombre después del ~
	DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/test.dialogue"), "estatua_antigua")
	
	# Esperar a que el diálogo se cierre para liberar al jugador
	await DialogueManager.dialogue_ended
	if jugador.has_method("set_physics_process"):
		jugador.set_physics_process(true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_en_rango = true
		# Opcional: Mostrar un iconito de "Presiona E" sobre la estatua
		print("Presiona E para leer")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_en_rango = false
