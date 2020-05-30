extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func save():  # this save fuction defines the variables to be saved for a node. every node to be saved will need one
	var save_dict = {
		"parent" : get_parent().get_path(),
		"path" : get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	return save_dict


func save_game(): #saves the game. can be called from anywhere in the tree
	var save_game = File.new()
	save_game.open(Gconst.SAVE_FILE_PATH, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load
#		if node.filename.empty():
#			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
#			continue

		# Check the node has a save function
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game(): #path independant
	var save_game = File.new()
	
	if not save_game.file_exists(Gconst.SAVE_FILE_PATH):
		print_debug("save file not found")
		return
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
	#	i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open(Gconst.SAVE_FILE_PATH, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		# var object = load(node_data["filename"]).instance()
		#get_node(node_data["parent"]).add_child(new_object)
		var node = get_node(node_data["path"])
		node.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
#		for i in node_data.keys():
#			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#				continue
#			new_object.set(i, node_data[i])
	save_game.close()
# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
