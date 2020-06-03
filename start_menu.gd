extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var config_file_path = Gconst.CONFIG_FILE_PATH
#var save_file_path
onready var save_file_popup = get_node("button_align/save_file_button/save_file_popup")
var config = {
	"save_file_path" : "user://hookshot.save"
}

func save_config():
	var config_file = File.new()
	config_file.open(Gconst.CONFIG_FILE_PATH,File.WRITE)
	config_file.store_line(to_json(config))

func load_config():
	var config_file = File.new()
	if !config_file.file_exists(Gconst.CONFIG_FILE_PATH):
			print_debug("config file not found")
			return
		
	config_file.open(Gconst.CONFIG_FILE_PATH,File.READ)
	config = parse_json(config_file.get_line())

func start_game():
#	get_node(Gconst.WORLD_PATH).pause_mode = Node.PAUSE_MODE_INHERIT
	get_tree().paused = false
	visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()
	
	#apply config to save_file_popup
	save_file_popup.current_file = config.save_file_path
	pass # Replace with function body.

func _enter_tree():
#	get_node(Gconst.WORLD_PATH).pause_mode = Node.PAUSE_MODE_STOP
	get_tree().paused = true
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_save_file_button_button_up():
	save_file_popup.popup()
	pass # Replace with function body.


func _on_start_button_button_up():
	start_game()
	pass # Replace with function body.
