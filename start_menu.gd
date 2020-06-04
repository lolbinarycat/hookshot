extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var config_file_path = Gconst.CONFIG_FILE_PATH
#var save_file_path
onready var save_file_popup = get_node("button_align/save_file_button/save_file_popup")
#var config = Gconst.config

func save_config():
	var config_file = File.new()
	config_file.open(Gconst.CONFIG_FILE_PATH,File.WRITE)
	config_file.store_line(to_json(Gconst.config))

func load_config():
	var config_file = File.new()
	if !config_file.file_exists(Gconst.CONFIG_FILE_PATH):
			print_debug("config file not found")
			return
		
	config_file.open(Gconst.CONFIG_FILE_PATH,File.READ)
	Gconst.config = parse_json(config_file.get_line())
#	Gconst.config = config

func start_game():
#	get_node(Gconst.WORLD_PATH).pause_mode = Node.PAUSE_MODE_INHERIT
	load_config()
	get_tree().paused = false
	visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()
	visible = true
	#apply config to save_file_popup
	pass # Replace with function body.

func _enter_tree():
#	get_node(Gconst.WORLD_PATH).pause_mode = Node.PAUSE_MODE_STOP
	get_tree().paused = true
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_save_file_button_button_up():
	load_config()
	save_file_popup.popup()
	save_file_popup.get_parent().hint_tooltip = Gconst.config.save_file_path
#	print_debug(save_file_popup.current_file)


func _on_start_button_button_up():
	start_game()
	pass # Replace with function body.


func _on_save_file_popup_file_selected(path):
	Gconst.config.save_file_path = path
	save_config()
#	print_debug(Gconst.config.save_file_path)
	pass # Replace with function body.
