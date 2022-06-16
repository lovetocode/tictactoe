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

var possible_win_x = []
var possible_win_o = []

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
		elif tally == 2:
			if letter == 'x':
				possible_win_x.append(key)
			else:
				possible_win_o.append(key)
			tally = 0 
				
		else:
			tally = 0 
	
	if win:
		won_game(checker_dict[key])
		
func won_game(win_key): # To make a win more interesting
	var inst = game_won.instance()
	var node = "POS" + String(win_key[1]) # The middle position of the whole key.
	inst.position = get_main_node().get_node(node).global_position
	var diff = win_key[2] - win_key[0]
	
	
	match diff: #equivalent to switch statement.
		4: # comes win key diagonal
			inst.rotation = deg2rad(-45)
		8: #this is too
			inst.rotation = deg2rad(45)
		6: #this is vertical.
			inst.rotation = deg2rad(90)
	
	get_main_node().add_child(inst)
	
func play_winning_move():
	var played_winning_move = false
	var played_pos = -1
	var key_to_remove = -1 # sometimes when possible wins are stored they might be taken by other players.
	
	
	# all possible win outcomes are stored in possible_win_o array
	if possible_win_o.size() > 0: #this means there is a winning possibility
		for i in range(0, possible_win_o.size()):
			# go through all these possibilites
			for j in range(0, checker_dict[possible_win_o[i]].size()):
				# go through all the positions in these possibilities
				if data_store[checker_dict[possible_win_o[i]][j]] == "--":
					#if a possible possition is empty
					played_pos = checker_dict[possible_win_o[i]][j] #what should be the possition to play
					key_to_remove = i
					# find the node for the position to play
					var node = "POS" + String(played_pos)
					get_main_node().get_node(node).play_o()
					played_winning_move = true
				if played_winning_move:
					return played_winning_move
					
			if key_to_remove != -1:
				possible_win_o.remove(key_to_remove)
			else:
				possible_win_o = []
	
	return played_winning_move # in case its false
					
					
		
	
func play_computer():
	var won_by_computer = play_winning_move() # first priority
	if won_by_computer:
		return          #game ends
	
	var blocked_players_win = block_players_win() # second priority
	if blocked_players_win:
		return                #no other move needed
#
#	var draw = check_for_draw() # third priority
#	if draw():
#		return                  #Its a stalemate noting to do
	
   #if nothing take a random pos and play

				
		
func _process(delta):
	if Input.is_key_pressed(KEY_ENTER):
		possible_win_o = []
		possible_win_x = []
		get_tree().reload_current_scene()
		reset_data_store()
		
	if Input.is_action_just_pressed("ui_select"): # for testing press space
		play_computer()
