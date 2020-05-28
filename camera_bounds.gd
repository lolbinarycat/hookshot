extends Area2D

const CAM_TOUT = 5 #number of frames after a camera transition you will be restriced from another for

onready var player = get_node(Gconst.PLAYER_PATH)
onready var camera_node = player.get_node("Camera2D")
var collis_shape
var size
var cam_change_timeout = 0 #current number of frames till restrictions are lifted

func reset_limits(cam):
	print_debug(cam)
	cam.set_limit(MARGIN_BOTTOM,10000000)
	cam.set_limit(MARGIN_LEFT,-10000000)
	cam.set_limit(MARGIN_RIGHT,10000000)
	cam.set_limit(MARGIN_TOP,-10000000)
	cam.position = Vector2(0,0)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#camera_node = get_node(Gconst.CAMERA_PATH)
	collis_shape = get_node("CollisionShape2D")
	#print_debug(camera_node)
	size = collis_shape.shape.extents


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cam_change_timeout > 0:
		cam_change_timeout -= 1


func _on_camera_bounds_body_exited(body):
	if body == player and cam_change_timeout <= 0:
		reset_limits(body.get_node("Camera2D"))


func _on_camera_bounds_body_entered(body):
	if body == player:
		camera_node.set_limit(MARGIN_RIGHT,position.x+size.x)
		camera_node.set_limit(MARGIN_LEFT,position.x-size.x)
		camera_node.set_limit(MARGIN_BOTTOM,position.y+size.y)
		camera_node.set_limit(MARGIN_TOP,position.y-size.y)
		cam_change_timeout = CAM_TOUT
	pass # Replace with function body.
