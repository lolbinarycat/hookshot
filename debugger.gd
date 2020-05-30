extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var test = null
var velocity_x
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
	set_item_text(1,format_float(player.velocity.x))
#	#get_node("velocity_x").text = String(player.velocity.y)
	set_item_text(3,String(player.get_tile_under()))
	pass


func _on_Player_ready():
	player = get_node(Gconst.PLAYER_PATH)
	
	add_item("velocity.x")
	add_item(String(player["velocity"].x))
	add_item("tile under player")
	add_item("e")
#	test = get_child(0)
#	print_debug(test)
#	if test == null:
#		print_debug("test is null")
#	else:
#		print_debug("test is not null")
	pass # Replace with function body.
