extends Control

@onready var p1_select: ItemList = $P1Select
@onready var selected_1: TextureRect = $SelectedChar1
@onready var p2_select: ItemList = $P2Select
@onready var selected_2: TextureRect = $SelectedChar2

var p1_selected_icon
var p1_selected_name
var p1_x = 0
var p1_y = 0

var p2_selected_icon
var p2_selected_name
var p2_x = 0
var p2_y = 0

const max_xy = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	highlight(1)
	highlight(2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p1_punch") and p1_select.visible:
		select(1)
	if event.is_action_pressed("p1_kick"):
		deselect(1)
	if event.is_action_pressed("p1_left") and p1_select.visible:
		left(1)
	if event.is_action_pressed("p1_right") and p1_select.visible:
		right(1)
	if event.is_action_pressed("p1_jump") and p1_select.visible:
		up(1)
	if event.is_action_pressed("p1_charge") and p1_select.visible:
		down(1)
		
	if event.is_action_pressed("p2_punch") and p2_select.visible:
		select(2)
	if event.is_action_pressed("p2_kick"):
		deselect(2)
	if event.is_action_pressed("p2_left") and p2_select.visible:
		left(2)
	if event.is_action_pressed("p2_right") and p2_select.visible:
		right(2)
	if event.is_action_pressed("p2_jump") and p2_select.visible:
		up(2)
	if event.is_action_pressed("p2_charge") and p2_select.visible:
		down(2)

func select(player):
	if player == 1:
		p1_select.item_selected.emit(p1_x+ max_xy*p1_y)
	else:
		p2_select.item_selected.emit(p2_x + max_xy*p2_y)

func deselect(player):
	if player == 1:
		selected_1.modulate.a = 0
		p1_select.visible = true
	else:
		selected_2.modulate.a = 0
		p2_select.visible = true

func left(player):
	if player == 1:
		var temp_x = p1_x-1 if p1_x>0 else 0
		if p1_select.is_item_disabled(temp_x + p1_y*max_xy):
			return
		p1_x = temp_x
		highlight(1)
	else:
		var temp_x = p2_x-1 if p2_x>0 else 0
		if p2_select.is_item_disabled(temp_x + p2_y*max_xy):
			return
		p2_x = temp_x
		highlight(2)

func right(player):
	if player == 1:
		var temp_x = p1_x+1 if p1_x<max_xy-1 else max_xy-1
		if p1_select.is_item_disabled(temp_x + p1_y*max_xy):
			return
		p1_x = temp_x
		highlight(1)
	else:
		var temp_x = p2_x+1 if p2_x<max_xy-1 else max_xy-1
		if p2_select.is_item_disabled(temp_x + p2_y*max_xy):
			return
		p2_x = temp_x
		highlight(2)
	
func up(player):
	if player == 1:
		var temp_y = p1_y-1 if p1_y>0 else 0
		if p1_select.is_item_disabled(p1_x + temp_y*max_xy):
			return
		p1_y = temp_y
		highlight(1)
	else:
		var temp_y = p2_y-1 if p2_y>0 else 0
		if p2_select.is_item_disabled(p2_x + temp_y*max_xy):
			return
		p2_y = temp_y
		highlight(2)

func down(player):
	if player == 1:
		var temp_y = p1_y+1 if p1_y<max_xy-1 else max_xy-1
		if p1_select.is_item_disabled(p1_x + temp_y*max_xy):
			return
		p1_y = temp_y
		highlight(1)
	else:
		var temp_y = p2_y+1 if p2_y<max_xy-1 else max_xy-1
		if p2_select.is_item_disabled(p2_x + temp_y*max_xy):
			return
		p2_y = temp_y
		highlight(2)

func highlight(player):
	if player == 1:
		p1_select.select(p1_x + p1_y*max_xy)
	else:
		p2_select.select(p2_x + p2_y*max_xy)
		

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
