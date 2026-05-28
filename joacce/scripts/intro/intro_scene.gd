extends Node3D

@export var path_follow: PathFollow3D
@export var title_label: Label
@export var duration: float = 10.0

func _ready() -> void:
	path_follow.progress_ratio = 0.0
	title_label.modulate.a = 0.0
	title_label.visible = true

	var camera_tween = create_tween()
	camera_tween.tween_property(
		path_follow,
		"progress_ratio",
		1.0,
		duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Call back to run once tweening ends
	camera_tween.tween_callback(func():
		get_tree().change_scene_to_file("res://scenes/o-test/menus/start_menu.tscn")
	)

	var title_tween = create_tween()

	# Wait before showing title
	title_tween.tween_interval(0.5)

	# Fast fade in
	title_tween.tween_property(
		title_label,
		"modulate:a",
		1.0,
		0.15
	)

	# Stay visible
	title_tween.tween_interval(3.5)

	# Fast fade out
	title_tween.tween_property(
		title_label,
		"modulate:a",
		0.0,
		0.1
	)

	title_tween.tween_callback(func():
		title_label.visible = false
	)
