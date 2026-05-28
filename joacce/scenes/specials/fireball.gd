extends Attack 

@export var ball_speed: float = 600.0
var ball_direction: Vector2 = Vector2.RIGHT

# holds a reference to the player who shot this fireball
var source_player: Node2D = null

func _ready() -> void:
	rotation = ball_direction.angle()

func _physics_process(delta: float) -> void:
	# moves the fireball forward smoothly based on the assigned direction
	global_position += ball_direction * ball_speed * delta

func _on_hitarea_body_entered(body: Node2D) -> void:
	if not is_instance_valid(source_player):
		return 
		
	if body == source_player:
		return
		
	if "id" in body:
		if body.id == source_player.id:
			return
			
		if body.has_method("apply_damage"):
			body.apply_damage(10) 
			
		queue_free() # delete the fireball AFTER successfully hitting the enemy
