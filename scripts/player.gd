extends CharacterBody2D

# Max numbers
var max_health: int = 5
var max_ammo: int = 10
var max_medkits: int = 3

# Attributes
var health: int = max_health

# Equipment
var ammo: int = max_ammo
var sword_damage: int = 1
var medkits: int = max_medkits

# Movement
const SPEED: int = 1000
const DASH_SPEED = SPEED * 3
const DASH_TIME = 0.3

# State Control
var dashing: bool = false
var can_move: bool = true
var mouse_direction: Vector2
var dash_direction: Vector2

# Signals
signal health_changed
signal ammo_changed
signal medkits_changed

# Node References
@onready var gun: Node2D = $Gun
@onready var animation_tree = $AnimationTree

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	animation_tree.active = true

func _process(_delta: float) -> void:
	input()
	
	if OS.is_debug_build():
		debug_input()

func _physics_process(_delta: float) -> void:
	mouse_direction = position.direction_to(get_global_mouse_position()).normalized()
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if dashing:
		velocity = dash_direction * DASH_SPEED
	else:
		velocity = direction * SPEED
		
	update_animation_player(direction)
	
	if can_move or dashing:
		move_and_slide()

func input():
	if Input.is_action_just_pressed("melee_attack"):
		melee_attack()
		
	if Input.is_action_just_pressed("dash"):
		dash()
		
	if Input.is_action_just_pressed("shoot") and ammo >= 1:
		shoot()
		
	if Input.is_action_just_pressed("medkit") and medkits >= 1:
		use_medkit()

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
	
	animation_tree["parameters/attack/blend_position"] = mouse_direction
	can_move = false
	animation_tree["parameters/conditions/attack"] = true
	
	await get_tree().create_timer(0.5).timeout
	
	animation_tree["parameters/conditions/attack"] = false
	can_move = true
	
func dash():
	dashing = true
	can_move = false
	animation_tree["parameters/conditions/dash"] = true
	
	dash_direction = mouse_direction
	await get_tree().create_timer(DASH_TIME).timeout
	
	dashing = false
	can_move = true
	animation_tree["parameters/conditions/dash"] = false
	
func shoot():
	if dashing:
		return
	
	can_move = false
	
	gun.shoot()
	ammo_changed.emit()
	
	can_move = true

func update_animation_player(direction):
	# Blend Positioning
	animation_tree["parameters/idle/blend_position"] = mouse_direction
	animation_tree["parameters/move/blend_position"] = direction
	animation_tree["parameters/dash/blend_position"] = mouse_direction
	
	# If player is idle, face mouse. If player is moving, face movement direction
	if direction == Vector2.ZERO:
		animation_tree["parameters/hurt/blend_position"] = mouse_direction
		animation_tree["parameters/death/blend_position"] = mouse_direction
	else:
		animation_tree["parameters/death/blend_position"] = direction
		animation_tree["parameters/hurt/blend_position"] = direction
	
	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO and not dashing)
	animation_tree.set("parameters/conditions/moving", velocity != Vector2.ZERO and not dashing)

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

func gain_ammo(value):
	ammo += value
	if ammo > max_ammo:
		ammo = max_ammo
	
	ammo_changed.emit()

func use_medkit():
	if health >= max_health:
		return
	
	medkits -= 1
	
	if medkits < 0:
		medkits = 0
	
	heal(max_health)
	medkits_changed.emit()
	
func gain_medkit():
	medkits += 1
	if medkits > max_medkits:
		medkits = max_medkits
	
	medkits_changed.emit()

func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(sword_damage)
		gain_ammo(1)
