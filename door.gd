extends StaticBody2D

signal door_activated
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



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



#	pass # Replace with function body.
