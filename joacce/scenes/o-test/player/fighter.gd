extends CharacterBody2D

var SPEED = 400.0
var JUMP_VELOCITY = -600.0

@onready var punch: Node2D = $Punch
@onready var kick: Node2D = $Kick
@onready var idle: Sprite2D = $Sprites/Idle
@onready var walk: AnimatedSprite2D = $Sprites/Walk
@onready var punch_frame: Sprite2D = $Sprites/Punch
@onready var kick_frame: Sprite2D = $Sprites/Kick
@onready var damage_frame: Sprite2D = $Sprites/Damage
@onready var special_1: AnimatedSprite2D = $Sprites/Special1
@onready var special_2: AnimatedSprite2D = $Sprites/Special2
@onready var charge: AnimatedSprite2D = $Sprites/Charge
@onready var charge_effect: GPUParticles2D = $Sprites/Charge/ChargeEffect
@onready var sprites: Node2D = $Sprites
@onready var charge_bar = $ProgressBar 
@onready var state_machine = $StateMachine

# UI related references
@onready var health_bar = $Canvas/Bars/Healthbar
@onready var meter_bar = $Canvas/Bars/Meterbar
@onready var bar_layer = $Canvas/Bars

#player distinct by player_id
@export var id := 1

var charge_speed = 70.0
var current_charge = 0.0
var max_charge = 100
var charge_stack = 1
const max_stack = 5

var player ={}

var health = 100
var attacking = false
var animation_playing = false
var charge_time = 0.0

var current_sprite

var anim_lock : bool

func _ready() -> void:
	# Initialize UI elements
	health_bar.init_health(health)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state_machine:
		state_machine.physics_update(delta)
	move_and_slide()
	

func lock():
	if anim_lock:
		print("already locked")
		return false
	anim_lock = true
	return true

func unlock():
	if not anim_lock:
		print("already unlocked")
		return false
	anim_lock = false
	return true 

func get_movement():
	var direction = Input.get_axis(
		"p"+str(id)+"_left",
		"p"+str(id)+"_right"
	)
	velocity.x = direction * SPEED

func apply_damage(damage) -> void:
	state_machine.change_state("damage")
	health -= damage
	# Update healthbar UI state
	health_bar.health = health
	print(name," took ", damage, " damage")

func _on_hitarea_body_entered(body: Node2D) -> void:
	if name != body.name:
		body.apply_damage(5)

func play_special(sprite: AnimatedSprite2D) -> void:
	current_sprite.visible = false
	sprite.visible = true
	sprite.play()
	if sprite == special_2:
		var dir = -1 if sprites.scale.x < 0 else 1
		velocity.x = dir * 200
		velocity.y = -600  # the "up" of uppercut
	await sprite.animation_finished
	sprite.visible = false
	current_sprite.visible = true


func switch_frame(sprite_name, duration = 0):
	if current_sprite:
		print(current_sprite)
		current_sprite.visible = false
	match sprite_name:
		"idle": 
			idle.visible = true
			current_sprite = idle
		"walk": 
			walk.visible = true
			current_sprite = walk
		"punch": 
			punch_frame.visible = true
			current_sprite = punch_frame
		"kick": 
			kick_frame.visible = true
			current_sprite = kick_frame
		"charge": 
			charge.visible = true
			current_sprite = charge
		"damage": 
			damage_frame.visible = true
			current_sprite = damage_frame
	if duration > 0: 
		await get_tree().create_timer(duration).timeout
		print("waited ", duration, " seconds")
	return current_sprite
