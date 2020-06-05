extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum {OPEN, CLOSED}
var door_state = OPEN
enum {PRESSED, UNPRESSED}
var open_button_state = UNPRESSED
# this is open_button to make it easyer to implement a close_button if i want to

onready var door        = get_node("door")
onready var open_pos    = get_node("open_pos")
onready var closed_pos  = get_node("closed_pos")
onready var open_button = get_node("open_button")

func save():
	var save_dict = {
		"path" : get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"door_state" : door_state,
		"open_button_state" : open_button_state
	}
	return save_dict
# Called when the node enters the scene tree for the first time.

func update_open_button_state():
	if open_button_state == UNPRESSED:
		open_button.get_node("CollisionShape2D").disabled = true
		open_button.get_node("Sprite").visible = false
	elif open_button_state == PRESSED:
		open_button.get_node("CollisionShape2D").disabled = false
		open_button.get_node("Sprite").visible = true

func _ready():
	update_door_state()
	update_open_button_state()
	pass # Replace with function body.

func update_door_state():
	if door_state == OPEN:
		door.global_position = open_pos.global_position
	elif door_state == CLOSED:
		door.global_position = closed_pos.global_position

func open_door():
#	global_position = get_node("activated_position").global_position
	door_state = OPEN
	update_door_state()
#emit_signal("door_activated")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_open_button_body_entered(body):
	if body == get_node(Gconst.PLAYER_PATH):
		open_door()
	open_button_state = PRESSED
	update_open_button_state()


func _on_respawn_pos_game_loaded():
#	update_door_state()
#	update_open_button_state()
	pass # Replace with function body.
