extends Control

@onready var p1_select: ItemList = $P1Select
@onready var selected_1: TextureRect = $SelectedChar1

var p1_selected_icon
var p1_selected_name
var p1_hovered_idx

const x_move = 1
const y_move = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1_hovered_idx = 0
	highlight(1)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p1_punch"):
		select(1)
	if event.is_action_pressed("p1_kick"):
		deselect(1)
	if event.is_action_pressed("p1_left"):
		left(1)
	if event.is_action_pressed("p1_right"):
		right(1)
	if event.is_action_pressed("p1_jump"):
		up(1)
	if event.is_action_pressed("p1_charge"):
		down(1)

func select(player):
	if player == 1:
		p1_select.item_selected.emit(p1_hovered_idx)

func deselect(player):
	if player == 1:
		selected_1.texture = p1_selected_icon
		selected_1.visible = false
		p1_select.visible = true

func left(player):
	if player == 1:
		var temp_idx = clamp(p1_hovered_idx-x_move, 0, p1_select.item_count-1)
		if p1_select.is_item_disabled(temp_idx):
			return
		p1_hovered_idx = temp_idx
		print(p1_hovered_idx)
		highlight(1)

func right(player):
	if player == 1:
		var temp_idx = clamp(p1_hovered_idx+x_move, 0, p1_select.item_count-1)
		if p1_select.is_item_disabled(temp_idx):
			return
		p1_hovered_idx = temp_idx
		print(p1_hovered_idx)
		highlight(1)
	
func up(player):
	if player == 1:
		var temp_idx = clamp(p1_hovered_idx-y_move, 0, p1_select.item_count-1)
		if p1_select.is_item_disabled(temp_idx):
			return
		p1_hovered_idx = temp_idx
		print(p1_hovered_idx)
		highlight(1)

func down(player):
	if player == 1:
		var temp_idx = clamp(p1_hovered_idx+y_move, 0, p1_select.item_count-1)
		if p1_select.is_item_disabled(temp_idx):
			return
		p1_hovered_idx = temp_idx
		print(p1_hovered_idx)
		highlight(1)

func highlight(player):
	if player == 1:
		p1_select.select(p1_hovered_idx)

func _on_p_1_select_item_selected(index: int) -> void:
	p1_selected_icon = p1_select.get_item_icon(index)
	p1_selected_name = p1_select.get_item_text(index)
	
	selected_1.texture = p1_selected_icon
	selected_1.visible = true
	p1_select.visible = false
