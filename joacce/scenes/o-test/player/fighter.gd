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

# SFX variables
@export var fireball_scene: PackedScene


#player distinct by player_id
@export var id := 1

var charge_speed = 70.0
var current_charge = 0.0
var max_charge = 100
var charge_stack = 0
const max_stack = 5

var player ={}

var health = 100
var attacking = false
var animation_playing = false
var charge_time = 0.0

func _ready() -> void:
	# Initialize UI elements
	health_bar.init_health(health)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var direction = 0

	if not is_on_floor():
		velocity += get_gravity() * delta

	# If a special/attack animation is running, skip all other input handling
	if animation_playing:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#move_and_slide()
		return

	if Input.is_action_just_pressed("p"+str(id)+"_jump") and is_on_floor_only():
		velocity.y = JUMP_VELOCITY
	
	if direction and not animation_playing:
		walk.visible = true
		walk.play()
		idle.visible = false
		velocity.x = direction * SPEED
	else:
		walk.visible = false
		walk.stop()
		if  not attacking:
			idle.visible = true
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if state_machine:
		state_machine.physics_update(delta)
	move_and_slide()
	

func apply_damage(damage) -> void:
	show_frame(damage_frame, 0.7)
	health -= damage
	# Update healthbar UI state
	health_bar.health = health
	print(name," took ", damage, " damage")

func _on_hitarea_body_entered(body: Node2D) -> void:
	if name != body.name:
		body.apply_damage(5)

func show_frame(frame: Sprite2D, duration: float) -> void:
	animation_playing = true
	attacking = true
	idle.visible = false
	frame.visible = true
	await get_tree().create_timer(duration).timeout
	attacking = false
	frame.visible = false
	idle.visible = true
	animation_playing = false
	
func play_special(sprite: AnimatedSprite2D) -> void:
	charge_stack -= 1
	if charge_stack < 0:
		charge_stack = 0
		
	meter_bar.update_charges(charge_stack)
	if sprite != special_2:
		special_fireball()
	animation_playing = true
	idle.visible = false
	charge.visible = false
	sprite.visible = true
	sprite.play()
	if sprite == special_2:
		var dir = -1 if sprites.scale.x < 0 else 1
		velocity.x = dir * 200
		velocity.y = -600  # the "up" of uppercut
	await sprite.animation_finished
	sprite.visible = false
	idle.visible = true
	animation_playing = false
	
	
func get_sprite(sprite_name) -> Node:
	match sprite_name:
		"idle": return $Sprites/Idle
		"walk": return $Sprites/Walk
		"punch": return $Sprites/Punch
		"kick": return $Sprites/Kick
		"charge": return $Sprites/Charge
		
	return null
	
func special_fireball() -> void:
	if not fireball_scene:
		return
	
	#if animation.frame < 1:
		#while animation.frame != 1:
			#await animation.frame_changed
	await get_tree().create_timer(0.5).timeout
		
	var fireball_fx = fireball_scene.instantiate()
	
	# who created the fireball so it doesn't hurt them
	fireball_fx.source_player = self
	
	fireball_fx.ball_direction = Vector2.LEFT if sprites.scale.x < 0 else Vector2.RIGHT
	fireball_fx.ball_speed = 600.0
	fireball_fx.scale = Vector2(0.2, 0.2) 
	
	var spawn_offset = Vector2(fireball_fx.ball_direction.x * 60.0, 0.0)
	
	fireball_fx.global_position = global_position + spawn_offset
	
	get_tree().current_scene.add_child(fireball_fx)
