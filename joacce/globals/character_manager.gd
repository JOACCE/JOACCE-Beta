extends Node

const RESOURCE_PATH = "res://assets/characters/resources"

func create_character(char_name, dir_name):
	var fighter_path : String = RESOURCE_PATH + "/" + char_name.replace(" ", "_")
	var new_fighter = CharacterData.new()
	
	new_fighter.name = char_name
	new_fighter.idle.texture = load(dir_name+'/idle.png')
	new_fighter.walk.texture = load(dir_name+'/walk.png')
	new_fighter.punch.texture = load(dir_name+'/punch.png')
	new_fighter.kick.texture = load(dir_name+'/kick.png')
	new_fighter.damage.texture = load(dir_name+'/damage.png')
	new_fighter.special1_1.texture = load(dir_name+'/fireball_charge.png')
	new_fighter.special1_2.texture = load(dir_name+'/fireball_action.png')
	new_fighter.special2_1.texture = load(dir_name+'/uppercut_charge.png')
	new_fighter.special2_2.texture = load(dir_name+'/uppercut_action.png')
	new_fighter.charge.texture = load(dir_name+'/charge.png')

	var error = ResourceSaver.save(new_fighter, fighter_path)
	if error == OK:
		print("Saved ", char_name, " as resource!")
	else:
		print("Save failed with error: ", error)
		
