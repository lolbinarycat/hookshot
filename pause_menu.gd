extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var menu_open = false

func update_menu_state():
	visible = menu_open
	get_tree().paused = menu_open
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
		
		update_menu_state()
#    if event is InputEventKey:
#        if event.pressed and event.scancode == KEY_ESCAPE:
#            get_tree().quit()


func _on_Button_button_up():
	if menu_open:
		get_tree().quit()
	pass # Replace with function body.


func _on_Button2_button_up():
	get_node(Gconst.PLAYER_PATH).global_position = Vector2(512,304)
	menu_open = false
	update_menu_state()


func _on_quit_button_button_up():
	get_tree().quit()



func _on_resume_button_button_down():
	menu_open = false
	update_menu_state()


#func _on_ret_to_title_button_button_up():
#	pass # Replace with function body.


func _on_ret_to_title_button_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
