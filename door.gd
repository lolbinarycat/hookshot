extends StaticBody2D

signal door_opened
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func save():
	var save_dict = {
		"path" : get_path(),
		"pos_x": position.x,
		"pos_y": position.y
	}
	return save_dict

func open_door():
	position.y += -64
	emit_signal("door_opened")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_body_entered(body):
	if body == get_node(Gconst.PLAYER_PATH):
		open_door()
	pass # Replace with function body.
