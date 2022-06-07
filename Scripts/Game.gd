extends Node

onready var checker_dict = {
	"row one" : [0,1,2],
	"row two" : [3,4,5],
	"row three" : [4,5,6],
	"col one" : [1,4,7],
	"col two" : [2,5,8],
	"col three" : [3,6,9],
	"dia one" : [0,4,8],
	"dia two" : [2,4,6]
}

var data_store = [] #stores current values in each pos
var win = false #check for win

func _ready():
	reset_data_store()
	
func reset_data_store():
	# puts empty values in data_store
	data_store = []
	for i in range(0,9):
		data_store[i] = "--"
		
func get_keys_for_value(): # returs keys containing a particular value
	var all_keys = checker_dict.keys()
	var keys  = []
	for i in range(0, all_keys.size):
		var values = checker_dict[String()]
		
		
func check_win(pos, letter):
	var tally
	var key = []
	var keys_to_check = get_keys_for_value()
		
func _process(delta):
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().reload_current_scene()
