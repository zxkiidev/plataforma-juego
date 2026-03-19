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
	if not sprite.flip_h:
		pivot.rotation_degrees = 0
	else:
		pivot.rotation_degrees = 180
