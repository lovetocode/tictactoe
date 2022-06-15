extends Node

onready var checker_dict = {
	"row one" : [0,1,2],
	"row two" : [3,4,5],
	"row three" : [6,7,8],
	"col one" : [0,3,6],
	"col two" : [1,4,7],
	"col three" : [2,5,8],
	"dia one" : [0,4,8],
	"dia two" : [2,4,6]
}

onready var game_won = preload("res://Scenes/GameWon.tscn")
var data_store = [] #stores current values in each pos
var win = false #check for win

#function to get the main node
func get_main_node():
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)

func _ready():
	reset_data_store()
	
func reset_data_store():
	# puts empty values in data_store
	win = false
	data_store = []
	for i in range(0,9):
		data_store.append("--")
		
func get_keys_for_value(value): # returs keys containing a particular value
	var all_keys = checker_dict.keys()
	var keys  = []
	for i in range(0, all_keys.size()):
		var values = checker_dict[String(all_keys[i])]
		for j in range(0, values.size()):
			if values[j] == value:
				keys.append(String(all_keys[i]))
	return keys
		
func check_win(pos, letter):
	var tally = 0 
	var key = []
	var keys_to_check = get_keys_for_value(pos)
	
	# check if win on all the keys
	for i in range(keys_to_check.size()):
		key = keys_to_check[i]
		for j in range(0, checker_dict[key].size()):
			if (data_store[checker_dict[key][j]] == letter):
				tally += 1
		
		if tally == 3:
			win = true
			break
		else:
			tally = 0 
	
	if win:
		won_game(checker_dict[key])
		
func won_game(win_key): # To make a win more interesting
	var inst = game_won.instance()
	var node = "POS" + String(win_key[1]) # The middle position of the whole key.
	inst.position = get_main_node().get_node(node).global_position
	var diff = win_key[2] - win_key[0]
	get_main_node().add_child(inst)
	
	match diff: #equivalent to switch statement.
		4: # comes win key diagonal
			inst.rotation = deg2rad(-45)
		8: #this is too
			inst.rotation = deg2rad(45)
		6: #this is vertical.
			inst.rotation = deg2rad(90)
				
		
func _process(delta):
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().reload_current_scene()
		reset_data_store()
