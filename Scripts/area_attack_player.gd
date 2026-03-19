extends Area2D

var sprite : Sprite2D
var pivot : Node2D
var are

func _ready() -> void:
	
	sprite = get_node("../../Sprite2D")
	pivot = get_parent()

func _process(delta: float) -> void:
	update_area()

func update_area():
	attack_r.disabled = true
	attack_l.disabled = true
	#if player.current_state == ATTACK_MELEE:
		#if not animated_sprite.flip_h:
			#attack_r.disabled = false
		#else:
			#attack_l.disabled = false
