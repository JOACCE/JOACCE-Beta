extends CharacterBody2D

var SPEED = 400.0
var JUMP_VELOCITY = -640.0

@onready var punch: Node2D = $Punch
@onready var kick: Node2D = $Kick
@onready var idle: Sprite2D = $Sprites/Idle
@onready var walk: AnimatedSprite2D = $Sprites/Walk
@onready var punch_frame: Sprite2D = $Sprites/Punch
@onready var kick_frame: Sprite2D = $Sprites/Kick
@onready var damage_frame: Sprite2D = $Sprites/Damage
@onready var win_frame: Sprite2D = $Sprites/Win
@onready var loss_frame: Sprite2D = $Sprites/Loss
@onready var special_1: AnimatedSprite2D = $Sprites/Special1
@onready var special_2: AnimatedSprite2D = $Sprites/Special2
@onready var charge: AnimatedSprite2D = $Sprites/Charge
@onready var charge_effect: CPUParticles2D = $Sprites/Charge/ChargeEffect
@onready var sprites: Node2D = $Sprites
@onready var charge_bar = $ProgressBar 
@onready var state_machine = $StateMachine

# UI related references
@onready var health_bar = $Canvas/Bars/Healthbar
@onready var meter_bar = $Canvas/Bars/Meterbar
@onready var bar_layer = $Canvas/Bars

# SFX variables
@export var fireball_scene: PackedScene

# Audio related references
@onready var fighter_audio = $Audio

#player distinct by player_id
@export var id := 1


var charge_speed = 70.0
var current_charge = 0.0
var max_charge = 100
var charge_stack = 1
const max_stack = 5

var player ={}
var previous_buttons := {}

var current_damage = 0

var match_enabled: bool = false

# Takes in the fighter id that reaches 0 hp
signal health_depleted(loser_id: int)
# As a setter, will run the function for every health change
var health = 100:
	set(value):
		health = value
		# 3. Check for the condition and emit
		if health <= 0:
			health_depleted.emit(id)

var attacking = false
var animation_playing = false
var charge_time = 0.0

var current_sprite

var anim_lock : bool

func _ready() -> void:
	# Initialize UI elements
	meter_bar.update_charges(charge_stack)

func _physics_process(delta: float) -> void:
	# Case when blocking movement
	if !match_enabled:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state_machine:
		state_machine.physics_update(delta)
	move_and_slide()
	

func lock():
	if anim_lock:
		return false
	anim_lock = true
	return true

func unlock():
	if not anim_lock:
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
	health_bar.take_damage(damage)

func _on_hitarea_body_entered(body: Node2D) -> void:
	if name != body.name and body.has_method("apply_damage"):
		body.apply_damage(current_damage)

func play_special(sprite: AnimatedSprite2D) -> void:
	if charge_stack<=0:
		return
	charge_stack -= 1
		
	meter_bar.update_charges(charge_stack)
	
	if sprite != special_2:
		special_fireball()
	animation_playing = true
	idle.visible = false
	charge.visible = false
	current_sprite.visible = false
	sprite.visible = true
	sprite.play()
	if sprite == special_2:
		fighter_audio.play_sfx("uppercut")
		current_damage = 20
		var dir = -1 if get_parent().facing_left == self else 1
		velocity.x = dir * 200
		velocity.y = -600  # the "up" of uppercut
		special_2.attack()
		
	await sprite.animation_finished
	sprite.visible = false
	current_sprite.visible = true


	
func switch_frame(sprite_name, duration = 0):
	if current_sprite:
		current_sprite.visible = false
	match sprite_name:
		"idle": 
			idle.visible = true
			current_sprite = idle
		"walk": 
			walk.visible = true
			current_sprite = walk
		"punch": 
			fighter_audio.play_sfx("punch")
			punch_frame.visible = true
			current_sprite = punch_frame
		"kick": 
			fighter_audio.play_sfx("kick")
			kick_frame.visible = true
			current_sprite = kick_frame
		"charge":
			charge.visible = true
			current_sprite = charge
		"damage": 
			fighter_audio.play_sfx("impact")
			damage_frame.visible = true
			current_sprite = damage_frame
		"win":
			win_frame.visible = true
			current_sprite = win_frame
		"loss":
			loss_frame.visible = true
			current_sprite = loss_frame

	if duration > 0: 
		await get_tree().create_timer(duration).timeout
	return current_sprite
	
func special_fireball() -> void:
	if not fireball_scene:
		return
	
	await get_tree().create_timer(0.5).timeout
		
	var fireball_fx = fireball_scene.instantiate()
	
	# who created the fireball so it doesn't hurt them
	fireball_fx.source_player = self
	
	fireball_fx.ball_direction = Vector2.LEFT if get_parent().facing_left == self else Vector2.RIGHT
	fireball_fx.ball_speed = 600.0
	fireball_fx.scale = Vector2(0.2, 0.2) 
	
	var spawn_offset = Vector2(fireball_fx.ball_direction.x * 60.0, 0.0)
	
	fireball_fx.global_position = global_position + spawn_offset
	
	# Play fireball SFX
	fighter_audio.play_sfx("fireball")
	
	get_tree().current_scene.add_child(fireball_fx)

func set_match_enabled(enabled: bool):
	match_enabled = enabled
	
	# Restrict movement
	if !match_enabled:
		velocity = Vector2.ZERO
		attacking = false
		animation_playing = false
		charge_time = 0.0
		if state_machine:
			state_machine.change_state("idle")

func set_sprites():
	var data = CharacterManager.get_char(id)
	idle.texture = data.idle
	punch_frame.texture = data.punch
	kick_frame.texture = data.kick
	damage_frame.texture = data.damage
	win_frame.texture = data.victory
	loss_frame.texture = data.loss
	apply_animation_frames(walk, [data.idle, data.walk])
	apply_animation_frames(charge, [data.charge])
	apply_animation_frames(special_1, [data.special1_1, data.special1_2])
	apply_animation_frames(special_2, [data.special2_1, data.special2_2])

func apply_animation_frames(sprite: AnimatedSprite2D, textures: Array):
	sprite.sprite_frames = sprite.sprite_frames.duplicate()
	var frames = sprite.sprite_frames
	var anim_name = frames.get_animation_names()[0]
	
	for i in textures.size():
		if i< frames.get_frame_count(anim_name):
			frames.set_frame(anim_name, i, textures[i])
		else:
			frames.add_frame(anim_name, textures[i])
	
