extends KinematicBody2D

const JUMP_HEIGHT = 250
const WALL_JUMP_HEIGHT = 150
const WALL_JUMP_WIDTH = 70
const RUN_SPEED = 20
const FRICTION = 1.09
const AIR_FRICTION =1.01
const AIR_SPEED = 4
const GRAVITY = 7.5
const IS_PLAYER = true

signal stop_hs
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# var player = KinematicBody2D.new()
var velocity = {
	x = 0,
	y = 0
}
var fallspeed = GRAVITY

var timeFromGround = 800
var timeFromWall = 800
enum {RIGHT, LEFT, NONE}
var lastWallDir = NONE
var hs_active = false
var hs_pulling = false

func go_to_spawnpoint():
	get_tree().reload_current_scene()
	#velocity = Vector2(0,0)
	#global_position = global_position + Vector2(4,0) #= get_parent().global_position

func get_which_wall_collided():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.normal.x > 0:
			return LEFT
		elif collision.normal.x < 0:
			return RIGHT
	return NONE
	
func stop_hs():
	emit_signal("stop_hs")
	hs_active = false
	hs_pulling = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

# warning-ignore:unused_argument
func _physics_process(delta):
	
	#if Input.is_action_just_pressed("reverse"):
	#	velocity.x = -velocity.x
	if hs_active:
		fallspeed = 0
	elif Input.is_action_pressed("jump"): #variable jump height and slow falling
		fallspeed = GRAVITY/2
	else:
		fallspeed = GRAVITY
	
	if !hs_active or hs_pulling:
		velocity = move_and_slide(Vector2(velocity.x,velocity.y),Vector2(0,-1))
	if hs_pulling and (is_on_wall() or is_on_ceiling()):
		stop_hs()
		
			
	

	if is_on_floor():
		timeFromGround = 0
	else:
		timeFromGround += 1*delta
		
	if !hs_active: #turns off input when hookshot is active
		if  Input.is_action_pressed("ui_right"):
			velocity.x += AIR_SPEED
		elif Input.is_action_pressed("ui_left"):
			velocity.x -= AIR_SPEED	
			
		if timeFromGround == 0:
			if Input.is_action_pressed("ui_right"):
				velocity.x += RUN_SPEED
			elif Input.is_action_pressed("ui_left"):
				velocity.x -= RUN_SPEED
			velocity.x = velocity.x / FRICTION
		else:
			velocity.y = velocity.y + fallspeed
			velocity.x = velocity.x / AIR_FRICTION
		
	if timeFromGround < 0.2:
		if Input.is_action_just_pressed("jump"):
			emit_signal("stop_hs")
			velocity.y = -JUMP_HEIGHT
			hs_active = false
			hs_pulling = false
	# start walljump proccesing
	if is_on_wall():
		timeFromWall = 0
		lastWallDir = get_which_wall_collided()
	else:
		timeFromWall += 1*delta
		
	if timeFromWall < 0.1 and Input.is_action_just_pressed("jump") and timeFromGround != 0  :
		velocity.y -= WALL_JUMP_HEIGHT
		if lastWallDir == RIGHT:
			velocity.x = -WALL_JUMP_WIDTH
		elif lastWallDir == LEFT:
			velocity.x = WALL_JUMP_WIDTH
			
	#spikes
	#if is_on_wall() or is_on_ceiling() or is_on_floor():
	#	if get_node(Gconst.TILEMAP_PATH).get_cellv(position) == 2:
	#		die()
		
	


func _on_hookshot_hs_extend():
	hs_active = true
	velocity = Vector2(0,0)


func _on_hookshot_hs_miss():
	hs_active = false
	velocity = Vector2(0,0)
	



func _on_hs_head_hs_hit(dir):
	hs_active = true
	hs_pulling = true
	if dir == Gconst.RIGHT:
		velocity = Vector2(Gconst.HS_PULL_SPEED*2,0)
	elif dir == Gconst.LEFT:
		velocity = Vector2(-Gconst.HS_PULL_SPEED*2,0)
	elif dir == Gconst.UP:
		velocity = Vector2(0,-Gconst.HS_PULL_SPEED*2)	
	elif dir == Gconst.DOWN:
		velocity = Vector2(0,Gconst.HS_PULL_SPEED*2)


func _on_death_plane_body_entered(body):
	if body == self:
		go_to_spawnpoint()
