extends Node

const RESOURCE_PATH = "res://assets/characters/resources"

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
	}

func create_character(char_name, buffers):
	var fighter_path : String = RESOURCE_PATH + "/" + char_name.replace(" ", "_")
	var new_fighter = CharacterData.new()
	
	new_fighter.name = char_name
	
	for filename in KEY_MAP:
		if buffers.has(filename):
			var img = Image.new()
			img.load_png_from_buffer(buffers[filename])
			new_fighter.get(KEY_MAP[filename]).texture = ImageTexture.create_from_image(img)
		else:
			print("Warning: Missing buffer for ", filename)
	
	var error = ResourceSaver.save(new_fighter, fighter_path)
	if error == OK:
		print("Saved ", char_name, " as resource!")
	else:
		print("Save failed with error: ", error)
		
