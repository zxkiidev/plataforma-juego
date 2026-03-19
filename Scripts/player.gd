extends CharacterBody2D

enum State { IDLE, RUN, JUMP, FALLING, ATTACK_MELEE }
var current_state = State.IDLE

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -280.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var last_look = "right"
var previous_state = State.IDLE  

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	handle_input()
	check_state_transitions()
	play_state_animation()

	move_and_slide()

func handle_input():
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
		last_look = "left" if direction < 0 else "right"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func check_state_transitions():
	if current_state == State.ATTACK_MELEE:
		return 
	if is_on_floor():
		if velocity.x != 0:
			current_state = State.RUN
		else:
			current_state = State.IDLE
	else:
		if velocity.y < 0:
			current_state = State.JUMP
		else:
			current_state = State.FALLING
	if Input.is_action_just_pressed("attack_melee"):
		current_state = State.ATTACK_MELEE

func play_state_animation():
	if current_state != previous_state:  
		match current_state:
			State.IDLE: animation_player.play("idle")
			State.RUN: animation_player.play("run")
			State.JUMP: animation_player.play("jump")
			State.FALLING: animation_player.play("falling")
			State.ATTACK_MELEE: animation_player.play("attack_melee")
		previous_state = current_state

	sprite.flip_h = (last_look == "left")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_melee":
		current_state = State.IDLE
