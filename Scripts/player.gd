extends CharacterBody2D

enum State { IDLE, RUN, JUMP, FALLING, ATTACK_MELEE }
var current_state = State.IDLE

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -280.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
			State.IDLE: animated_sprite_2d.play("idle")
			State.RUN: animated_sprite_2d.play("run")
			State.JUMP: animated_sprite_2d.play("jump")
			State.FALLING: animated_sprite_2d.play("falling")
			State.ATTACK_MELEE: animated_sprite_2d.play("attack_melee")
		previous_state = current_state

	animated_sprite_2d.flip_h = (last_look == "left")

func _on_animated_sprite_2d_animation_finished() -> void:
	if current_state == State.ATTACK_MELEE:
		current_state = State.IDLE
