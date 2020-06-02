extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var menu_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = menu_open
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		if menu_open:
			menu_open = false
		else:
			menu_open = true
		
		visible = menu_open
		get_tree().paused = menu_open
#    if event is InputEventKey:
#        if event.pressed and event.scancode == KEY_ESCAPE:
#            get_tree().quit()


func _on_Button_button_up():
	if menu_open:
		get_tree().quit()
	pass # Replace with function body.
