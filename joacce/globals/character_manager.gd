extends Node

const SAVE_PATH = "user://characters/"
const DEF_PATH = "res://assets/characters/resources/"
const KEY_MAP = {
		"idle.png":"idle",
		"walk.png":"walk",
		"punch.png":"punch",
		"kick.png":"kick",
		"damage.png":"damage",
		"fireball_charge.png":"special1_1",
		"fireball_action.png":"special1_2",
		"uppercut_charge.png":"special2_1",
		"uppercut_action.png":"special2_2",
		"charge.png":"charge",
		"victory.png":"victory",
		"loss.png":"loss"
	}

var char1
var char2

func get_all_characters()->Array:
	var characters = []
	
	
	var dir = DirAccess.open(DEF_PATH)
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".res"):
				var fighter = ResourceLoader.load(DEF_PATH + filename)
				characters.append(fighter)
			filename = dir.get_next()
	
	dir = DirAccess.open(SAVE_PATH)
	
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".res"):
				var fighter = ResourceLoader.load(SAVE_PATH + filename)
				characters.append(fighter)
			filename = dir.get_next()
	return characters

func get_char(id):
	var char_name = char1 if id == 1 else char2
	char_name = char_name.replace(" ", "_")
	var dir = DirAccess.open(DEF_PATH)
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".res") and filename == char_name+".res":
				var fighter = ResourceLoader.load(DEF_PATH + filename)
				return fighter
			filename = dir.get_next()

	dir = DirAccess.open(SAVE_PATH)
	
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".res") and filename == char_name+".res":
				var fighter = ResourceLoader.load(SAVE_PATH + filename)
				return fighter
			filename = dir.get_next()
	print("Using EJ default")
	return ResourceLoader.load(DEF_PATH+"EJ.res")

func create_character(char_name, buffers):
	var fighter_path : String = SAVE_PATH + char_name.replace(" ","_") + ".res"
	
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_PATH)
	
	var new_fighter = CharacterData.new()
	new_fighter.name = char_name
	
	for filename in KEY_MAP:
		if buffers.has(filename):
			var img = Image.new()
			img.load_png_from_buffer(buffers[filename])
			new_fighter.set(KEY_MAP[filename], ImageTexture.create_from_image(img))
		else:
			print("Warning: Missing buffer for ", filename)
	
	var error = ResourceSaver.save(new_fighter, fighter_path, ResourceSaver.FLAG_COMPRESS)
	if error == OK:
		print("Saved ", char_name, " to ", fighter_path)
	else:
		print("Save failed with error: ", error)

func char_select(player, char):
	if player == 1:
		char1 = char
	else:
		char2 = char
	print("Player ", player, " chose ", char)
