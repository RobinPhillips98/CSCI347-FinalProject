extends CharacterBody2D

# Base numbers
var max_health: int = 5
var max_shield: float = 0.0
var max_stamina: float = 50.0
var max_ammo: int = 5

# Attributes
var health: int = max_health
var shield: float = max_shield
var stamina: float = max_stamina
var stamina_regen_rate: float = 25
var ammo: int = max_ammo

# Movement
const SPEED = 600
const DASH_SPEED = SPEED * 4
const DASH_TIME = 0.4

# State Control
var dashing: bool = false
var can_move: bool = true
signal health_changed

# Node References
@onready var gun = $Gun
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
func _process(_delta: float) -> void:
	input()
	
	if OS.is_debug_build():
		debug_input()

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dashing:
		velocity = direction * DASH_SPEED
	else:
		velocity = direction * SPEED
	
	update_animation_player(direction)
	if can_move:
		move_and_slide()

func input():
	
	if Input.is_action_just_pressed("melee_attack"):
		melee_attack()
		
	if Input.is_action_just_pressed("dash"):
		dash()
		
	if Input.is_action_just_pressed("shoot") and ammo >= 1:
		shoot()
		

func debug_input():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/colony/colony.tscn")
		
	if Input.is_action_just_pressed("debug_health_down"):
		take_damage(1)
	
	if Input.is_action_just_pressed("debug_health_up"):
		heal(1)

func melee_attack():
	if dashing:
		return
	
	animation_tree["parameters/attack/blend_position"] = position.direction_to(get_global_mouse_position()).normalized()
	can_move = false
	animation_tree["parameters/conditions/attack"] = true
	await get_tree().create_timer(0.5).timeout
	animation_tree["parameters/conditions/attack"] = false
	can_move = true
	
func dash():
	dashing = true
	await get_tree().create_timer(DASH_TIME).timeout
	dashing = false
	
func shoot():
	if dashing:
		return
	
	can_move = false
	gun.shoot()
	can_move = true

func update_animation_player(direction):
	if direction != Vector2.ZERO:
		#animation_tree["parameters/attack/blend_position"] = direction
		animation_tree["parameters/dash/blend_position"] = direction
		animation_tree["parameters/death/blend_position"] = direction
		animation_tree["parameters/hurt/blend_position"] = direction
		animation_tree["parameters/move/blend_position"] = direction
	else:
		animation_tree["parameters/idle/blend_position"] = position.direction_to(get_global_mouse_position()).normalized()
		animation_tree["parameters/hurt/blend_position"] = position.direction_to(get_global_mouse_position()).normalized()
		animation_tree["parameters/death/blend_position"] = position.direction_to(get_global_mouse_position()).normalized()
		
	
	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO and not dashing)
	animation_tree.set("parameters/conditions/moving", velocity != Vector2.ZERO and not dashing)
	animation_tree.set("parameters/conditions/dash", dashing)

func heal(value):
	health += value
	if health > max_health:
		health = max_health
		
	health_changed.emit()

func take_damage(damage):
	can_move = false
	health -= damage
	
	animation_tree["parameters/conditions/hurt"] = true
	await get_tree().create_timer(0.3).timeout
	animation_tree["parameters/conditions/hurt"] = false
	
	if health <= 0:
		die()
		
	health_changed.emit()
	
	if health > 0:
		can_move = true

func die():
	can_move = false
	animation_tree["parameters/conditions/dead"] = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/colony/colony.tscn")
