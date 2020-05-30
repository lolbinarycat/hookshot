extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var hs
var test = null
var velocity_x
#so many things could have prevented this horrible 
#workaround from being neccececary
#for example:
#pointers
#lambdas
#functions being first class variables
#eval or exec
#basicaly any other programming language has a MUCH better way
#but apperently exec is "too hacky", so i have to do this instead
func get_and_format_player_velocity_x():
	return format_float(player.velocity.x)
func get_and_format_player_velocity_y():
	return format_float(player.velocity.y)
var debug_items = [ #label, function name
	["velocity.x",funcref(self,"get_and_format_player_velocity_x")],
	["velocity.y",funcref(self,"get_and_format_player_velocity_y")]
]
	

# Called when the node enters the scene tree for the first time.
func format_float(f,tdig = 6): # tdig = target digits
	if len(String(f)) <= tdig:
		return String(f)
	var num_whole_dig = len(String(round(f)))
	if num_whole_dig < tdig:
#		breakpoint
		return String(stepify(f,pow(0.1,tdig-num_whole_dig))) #
	else:
		return String(round(f))
#	else:
#		return "f"

func _ready():
	player = get_node(Gconst.PLAYER_PATH)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	var i = 0
	while i < len(debug_items):
		set_item_text(i*2+1,debug_items[i][1].call_func())
		i += 1
	#set_item_text(1,format_float(player.velocity.x))
	#set_item_text(3,format_float(player.velocity.y))
#	#get_node("velocity_x").text = String(player.velocity.y)
#	set_item_text(5,String(player.get_tile_under()))
#	if hs != null:
#		set_item_text(7,String(hs.hs_speed))
#		set_item_text(9,String(hs.hs_state))
#	pass


func _on_Player_ready():
	player = get_node(Gconst.PLAYER_PATH)
	
	var i = 0
	while i < len(debug_items):
		add_item(debug_items[i][0])
		add_item("E")
		i += 1
	#add_item("velocity.x")
	#add_item(String(player["velocity"].x))
	#add_item("velocity.y")
	#add_item("E")
#	add_item("tile under player")
#
#
#	hs = get_node(Gconst.HOOKSHOT_PATH)
#	add_item("hs_speed")
#	add_item("E")
#	add_item("hs_state")
#	add_item("E")
#	test = get_child(0)
#	print_debug(test)
#	if test == null:
#		print_debug("test is null")
#	else:
#		print_debug("test is not null")
	pass # Replace with function body.


func _on_hookshot_ready():

	pass # Replace with function body.
