extends Node

# Declare member variables here. Examples:
# var a = 2  
# var b = "text"
const D_VECTOR_CO = 1 # diaganal vector coefficent
const HS_PULL_SPEED = 100
enum {LEFT,RIGHT,UP,DOWN,DOWN_RIGHT,DOWN_LEFT,UP_RIGHT,UP_LEFT}
const PLAYER_PATH = NodePath("/root/Node2D/WorldEnvironment/respawn_pos/Player/")
const TILEMAP_PATH = NodePath("/root/Node2D/WorldEnvironment/TileMap/")
const HOOKSHOT_PATH = NodePath("/root/Node2D/WorldEnvironment/respawn_pos/Player/hookshot/")
const SAVE_FILE_PATH = "user://hookshot.save"
const TILES = {
	"spikes" : 2,
	"checkpoint" : 3
}
#var player = get_root()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
