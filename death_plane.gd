extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_node(Gconst.PLAYER_PATH)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_death_plane_body_entered(body):
#	if body == player:
#		player.go_to_spawnpoint()
