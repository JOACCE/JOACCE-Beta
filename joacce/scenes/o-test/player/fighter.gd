extends CharacterBody2D

var SPEED = 400.0
var JUMP_VELOCITY = -600.0

@onready var progress_bar: ProgressBar = $Healthbar/ProgressBar
@onready var punch: Node2D = $Punch
@onready var kick: Node2D = $Kick
@onready var alt_marker: Marker2D = $Healthbar/AltMarker
@onready var idle: Sprite2D = $Sprites/Idle
@onready var walk: AnimatedSprite2D = $Sprites/Walk
@onready var punch_frame: Sprite2D = $Sprites/Punch
@onready var kick_frame: Sprite2D = $Sprites/Kick
@onready var damage_frame: Sprite2D = $Sprites/Damage
@onready var special_1: AnimatedSprite2D = $Sprites/Special1
@onready var special_2: AnimatedSprite2D = $Sprites/Special2
@onready var charge: AnimatedSprite2D = $Sprites/Charge
@onready var charge_effect: GPUParticles2D = $Sprites/Charge/ChargeEffect

@onready var charge_bar = $ProgressBar 
var charge_speed = 20.0
var current_charge = 0.0
var max_charge = 100

var player ={}
#player distinct by player_id
@export var player_id := 1

var health = 100
var attacking = false
var animation_playing = false
var charge_time = 0.0

func _ready() -> void:
	progress_bar.max_value = health
	progress_bar.value = health
	
	
	if "2" in name:
		SPEED = SPEED
		JUMP_VELOCITY = JUMP_VELOCITY
		progress_bar.position = alt_marker.position
		$Sprites.scale.x = -1



func _physics_process(delta: float) -> void:
	# Add the gravity.
	var direction = 0

	if not is_on_floor():
		velocity += get_gravity() * delta

	# If a special/attack animation is running, skip all other input handling
	if animation_playing:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("special1"):
		play_special(special_1)
		return
	if Input.is_action_just_pressed("special2"):
		play_special(special_2)
		return

	if Input.is_action_just_pressed("punch"):
		punch.attack()
		#
	
		
	
	if player_id == 1:
		if Input.is_action_pressed("p1_move_left"):
			direction -=1
		if Input.is_action_pressed("p1_move_right"):
			direction +=1
			print("Player 1 is moving")

		if Input.is_action_pressed("p1_jump") and is_on_floor_only():
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("kick"):
			kick.attack()
		if Input.is_action_pressed("p1_charge"):
			if current_charge < max_charge:
				$ProgressBar.visible = true
				current_charge += charge_speed * delta
				charge_bar.value = current_charge
		if Input.is_action_just_released("p1_charge"):
			$ProgressBar.visible = false
			print("Charged")
			current_charge = 0
			charge_bar.value = current_charge
	if player_id == 2:
		if Input.is_action_pressed("p2_move_left"):
			direction -=1
			print("Player 2 is moving")

		if Input.is_action_pressed("p2_move_right"):
			direction +=1
			print("Player 2 is moving")

		if Input.is_action_pressed("p2_jump") and is_on_floor_only():
			
			velocity.y = JUMP_VELOCITY
	if direction:
		show_frame(punch_frame, 1.0)
	if Input.is_action_just_pressed("kick"):
		kick.attack()
		show_frame(kick_frame, 1.0)

	# Charge only if not also pressing a direction (avoids Shift+Right ambiguity)
	var charging = Input.is_action_pressed("charge")
	if charging:
		charge_time += delta
	else:
		charge_time = 0.0

	var show_charge = charging and charge_time >= 0.5 and is_on_floor()
	charge.visible = show_charge
	if show_charge:
		idle.visible = false

	direction = Input.get_axis("left", "right")
	if direction and not charging:
		walk.visible = true
		walk.play()
		idle.visible = false
		velocity.x = direction * SPEED
			
	else:
		walk.visible = false
		walk.stop()
		if not charging and not attacking:
			idle.visible = true
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func apply_damage(damage) -> void:
	show_frame(damage_frame, 0.7)
	health -= damage
	progress_bar.value  = health
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
	animation_playing = true
	idle.visible = false
	charge.visible = false
	sprite.visible = true
	sprite.play()
	if sprite == special_2:
		var dir = -1 if $Sprites.scale.x < 0 else 1
		velocity.x = dir * 200
		velocity.y = -600  # the "up" of uppercut
	await sprite.animation_finished
	sprite.visible = false
	idle.visible = true
	animation_playing = false
