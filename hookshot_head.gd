extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal hs_hit 
#enum {LEFT,RIGHT,UP,DOWN}
var hs_dir #= get_parent()
var collision
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
# warning-ignore:unused_argument
func _physics_process(delta):
	if get_parent().hs_state == 1:
		hs_dir = get_parent().hs_dir
		if hs_dir == Gconst.RIGHT:
			position.x = -10
			collision = move_and_collide(Vector2(10,0))
		elif hs_dir == Gconst.LEFT:
			position.x = 10
			collision = move_and_collide(Vector2(-10,0))
		elif hs_dir == Gconst.UP:
			position.y = 10
			collision = move_and_collide(Vector2(0,-10))
		elif hs_dir == Gconst.DOWN:
			position.y = -10
			collision = move_and_collide(Vector2(0,10))
		elif hs_dir == Gconst.DOWN_RIGHT:
			position.x = -10
			position.y = -10
			collision = move_and_collide(Vector2(10,10))
		elif hs_dir == Gconst.DOWN_LEFT:
			position = Vector2(10,-10)
			collision = move_and_collide(Vector2(-10,10))
		elif hs_dir == Gconst.UP_RIGHT:
			position = Vector2(-10,10)
			collision = move_and_collide(Vector2(10,-10))
		elif hs_dir == Gconst.UP_LEFT:
			position = Vector2(10,10)
			collision = move_and_collide(Vector2(-10,-10))
		if collision:
			emit_signal("hs_hit",hs_dir)
			#print_debug("sending hs_hit signal")
	else:
		position = Vector2(0,0)
