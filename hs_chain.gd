extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hs 
var player 
var default_region = get_region_rect()
# Called when the node enters the scene tree for the first time.
func _ready():
	hs = get_parent()
	player = hs.get_parent()
	default_region = get_region_rect()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if hs.hs_dist != 0:
#		set_region_rect( Rect2(default_region.position,Vector2(hs.hs_dist,3)) )
		set_region_rect( Rect2(default_region.position,Vector2(hs.get_global_position().distance_to(player.get_global_position())/2,3)) )
		if hs.hs_dir == Gconst.RIGHT:
			set_rotation_degrees(180)
		elif hs.hs_dir == Gconst.UP:
			set_rotation_degrees(90)
		elif hs.hs_dir == Gconst.LEFT:
			set_rotation_degrees(0)
		elif hs.hs_dir == Gconst.DOWN:
			set_rotation_degrees(270)
		elif hs.hs_dir == Gconst.DOWN_RIGHT:
			set_rotation_degrees(180+45)
		elif hs.hs_dir == Gconst.DOWN_LEFT:
			set_rotation_degrees(315)
			
	if hs.hs_state == hs.INACTIVE:
		visible = false
	else:
		visible = true
#	pass
