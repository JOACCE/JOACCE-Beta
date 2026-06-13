extends Control

# Popup
@onready var popup : CenterContainer = $CenterContainer
@onready var popup_label : Label = $CenterContainer/VBoxContainer/Label

@onready var deletion: Control = $Deletion
@onready var char_list: ItemList = $Deletion/CharList

# Menu Buttons
@onready var fight_button : Button = $VBoxContainer/Fight
@onready var create_button : Button = $VBoxContainer/Create
@onready var quit_button : Button = $VBoxContainer/Quit

func _on_fight_pressed() -> void:
	AudioManager.play_click_sfx()
	AudioManager.play_music("fight")
	get_tree().change_scene_to_file("res://scenes/character-select/selection.tscn")

func _on_create_pressed() -> void:
	var chars = CharacterManager.get_all_characters()
	var char_count = chars.size()
	print(char_count)
	if (OS.get_name() == "Web"):
		if char_count >= 9:
			prompt_char_deletion()
		else:
			get_tree().change_scene_to_file("res://scenes/character_creation/camera_capture_web/camera_input.tscn")
	#elif (OS.get_name() == "Windows"):
		#get_tree().change_scene_to_file("res://scenes/character_creation/camera_capture_windows/camera_input.tscn")
	elif (OS.get_name() in ["macOS", "Linux", "Android", "iOS"]):
		# Camera selection works with Goot CameraServer
		if char_count >= 9:
			prompt_char_deletion()
		else:
			get_tree().change_scene_to_file("res://scenes/character_creation/camera_select/camera_select.tscn")
	else:
		_disable_menu_buttons()
		popup_label.text = "Character creation not supported on " + OS.get_name()
		popup.show()

func _on_quit_pressed() -> void:
	AudioManager.play_click_sfx()
	get_tree().quit()


func _on_dismiss_button_pressed() -> void:
	AudioManager.play_click_sfx()
	_enable_menu_buttons()
	popup.hide()


func _enable_menu_buttons() -> void:
	fight_button.disabled = false
	create_button.disabled = false
	quit_button.disabled = false


func _disable_menu_buttons() -> void:
	fight_button.disabled = true
	create_button.disabled = true
	quit_button.disabled = true

func _on_fight_mouse_entered() -> void:
	AudioManager.play_hover_sfx()


func _on_create_mouse_entered() -> void:
	AudioManager.play_hover_sfx()


func _on_quit_mouse_entered() -> void:
	AudioManager.play_hover_sfx()


func _on_dismiss_button_mouse_entered() -> void:
	AudioManager.play_hover_sfx()
	
func prompt_char_deletion():
	_disable_menu_buttons()
	var customs = CharacterManager.get_customs()
	char_list.clear()
	for custom_char in customs:
		char_list.add_item(custom_char.name, custom_char.idle)
	deletion.show()
	


func _on_del_confirm_button_pressed() -> void:
	AudioManager.play_click_sfx()
	_enable_menu_buttons()
	deletion.hide()
	var selected_idx = char_list.get_selected_items()[0]
	var selected_name = char_list.get_item_text(selected_idx)
	CharacterManager.delete(selected_name)

func _on_del_dismiss_button_pressed() -> void:
	AudioManager.play_click_sfx()
	_enable_menu_buttons()
	deletion.hide()
