extends Area2D

@onready var sprite : Sprite2D = get_node("../../Sprite2D")
@onready var pivot : Node2D = get_parent()

func _process(_delta: float) -> void:
	update_area()

func update_area():
	if not sprite.flip_h:
		pivot.scale.x = 1 
	else:
		pivot.scale.x = -1
