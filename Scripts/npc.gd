extends StaticBody2D

# Variables configurables desde el Inspector
@export var titulo_bloque_dialogo: String = "estatua_antigua"
@export var recurso_dialogo: DialogueResource = preload("res://Dialogues/test.dialogue")

@onready var icono_e = $IconoE
var jugador_cerca: bool = false

func _ready():
	# Conexión automática de señales
	$AreaInteraccion.body_entered.connect(_on_area_interaccion_body_entered)
	$AreaInteraccion.body_exited.connect(_on_area_interaccion_body_exited)
	
	# Empezamos con el icono oculto
	if icono_e:
		icono_e.visible = false

func _input(event):
	# Importante: Revisa si en tu Input Map se llama "interact" o "interactuar"
	# Aquí uso "interact" porque es lo que tenías en tu script viejo
	if jugador_cerca and event.is_action_pressed("interact"):
		if icono_e: icono_e.visible = false 
		abrir_dialogo()

func abrir_dialogo():
	var jugador = get_tree().get_first_node_in_group("Jugador")
	
	# Bloqueamos movimiento
	if jugador and jugador.has_method("set_physics_process"):
		jugador.set_physics_process(false) 

	# CARGA DE BALLOON: Asegúrate de que la ruta sea correcta
	# En tu viejo era "res://Dialogues/balloon.tscn", en el nuevo "res://UI/balloon.tscn"
	# He puesto la de Dialogues que parece la original
	var balloon_scene = load("res://Dialogues/balloon.tscn")
	var balloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)
	
	# Iniciamos el diálogo
	balloon.start(recurso_dialogo, titulo_bloque_dialogo)
	
	# Esperamos a que termine
	await DialogueManager.dialogue_ended
	
	# Desbloqueamos jugador
	if jugador and jugador.has_method("set_physics_process"):
		jugador.set_physics_process(true)
	
	# Si al terminar sigue ahí, mostramos la E otra vez
	if jugador_cerca and icono_e:
		icono_e.visible = true

# --- SEÑALES DEL AREA ---

func _on_area_interaccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_cerca = true
		if icono_e: icono_e.visible = true
		print("Jugador detectado: Presiona E")

func _on_area_interaccion_body_exited(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_cerca = false
		if icono_e: icono_e.visible = false
