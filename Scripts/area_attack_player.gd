extends Area2D

var animated_sprite : AnimatedSprite2D
var player : CharacterBody2D
@onready var attack_r: CollisionShape2D = $attackR
@onready var attack_l: CollisionShape2D = $attackL

func _ready() -> void:
	player = get_parent()
	animated_sprite = get_node("../AnimatedSprite2D")

func _process(delta: float) -> void:
	pass

func update_area():
	attack_r.disabled = true
	attack_l.disabled = true
	#if player.current_state == ATTACK_MELEE:
		#if not animated_sprite.flip_h:
			#attack_r.disabled = false
		#else:
			#attack_l.disabled = false
