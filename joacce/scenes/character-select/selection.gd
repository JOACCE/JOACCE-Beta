extends Control

@onready var p1_select: ItemList = $P1Select
@onready var selected_1: TextureRect = $SelectedChar1
@onready var p2_select: ItemList = $P2Select
@onready var selected_2: TextureRect = $SelectedChar2
@onready var p1_controls: Label = $P1Controls
@onready var p2_controls: Label = $P2Controls
@onready var empty_texture : TextureRect = $EmptyTexture
var p1_selected_icon
var p1_selected_name
var p2_selected_icon
var p2_selected_name

var pos = [Vector2i.ZERO, Vector2i.ZERO]
const MAX_XY = 3
var char_arr

func _ready() -> void:
	char_arr = CharacterManager.get_all_characters()
	
	_update_items()
	
	highlight(1)
	highlight(2)
	
	_change_control_text()

func _input(event: InputEvent) -> void:
	for p in [1, 2]:
		var sel := _get_select(p)
		if event.is_action_pressed("p%d_punch" % p) and sel.visible:
			select(p)
		if event.is_action_pressed("p%d_kick" % p):
			deselect(p)
		if event.is_action_pressed("p%d_left" % p) and sel.visible:
			move(p, Vector2i(-1, 0))
		if event.is_action_pressed("p%d_right" % p) and sel.visible:
			move(p, Vector2i(1, 0))
		if event.is_action_pressed("p%d_jump" % p) and sel.visible:
			move(p, Vector2i(0, -1))
		if event.is_action_pressed("p%d_charge" % p) and sel.visible:
			move(p, Vector2i(0, 1))


func _get_select(player: int) -> ItemList:
	return p1_select if player == 1 else p2_select


func _get_display(player: int) -> TextureRect:
	return selected_1 if player == 1 else selected_2


func _idx(player: int) -> int:
	var p = pos[player - 1]
	return p.x + p.y * MAX_XY


func select(player: int) -> void:
	_get_select(player).item_selected.emit(_idx(player))


func deselect(player: int) -> void:
	_get_display(player).modulate.a = 0
	_get_select(player).visible = true


func move(player: int, dir: Vector2i) -> void:
	var p = pos[player - 1]
	var new_p := Vector2i(
		clamp(p.x + dir.x, 0, MAX_XY - 1),
		clamp(p.y + dir.y, 0, MAX_XY - 1)
	)
	if _get_select(player).is_item_disabled(new_p.x + new_p.y * MAX_XY):
		return
	pos[player - 1] = new_p
	highlight(player)


func highlight(player: int) -> void:
	_get_select(player).select(_idx(player))

func _change_control_text():
	print(InputMap.get_action_description("p1_punch"))

func _on_p_1_select_item_selected(index: int) -> void:
	p1_selected_icon = p1_select.get_item_icon(index)
	p1_selected_name = p1_select.get_item_text(index)
	selected_1.texture = p1_selected_icon
	selected_1.modulate.a = 255
	p1_select.visible = false


func _on_p_2_select_item_selected(index: int) -> void:
	p2_selected_icon = p2_select.get_item_icon(index)
	p2_selected_name = p2_select.get_item_text(index)
	selected_2.texture = p2_selected_icon
	selected_2.modulate.a = 255
	p2_select.visible = false

func _update_items():
	p1_select.clear()
	p2_select.clear()
	for i in MAX_XY*MAX_XY:
		if i < char_arr.size():
			p1_select.add_item(char_arr[i].name, char_arr[i].idle)
			p2_select.add_item(char_arr[i].name, char_arr[i].idle)
		else:
			p1_select.add_item("???", empty_texture.texture)
			p2_select.add_item("???", empty_texture.texture)
			p1_select.set_item_disabled(i, true)
			p2_select.set_item_disabled(i, true)
