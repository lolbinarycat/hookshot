extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var button_pushed = false

func update_button_state():
	if button_pushed:
		get_node("CollisionShape2D").disabled = true
		get_node("Sprite").visible = false

#func save():
#	var save_dict = {
#		"path" : get_path(),
#		"button_pushed"
#	}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_door_door_activated():
#	queue_free()
#	pass # Replace with function body.
