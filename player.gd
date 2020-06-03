extends KinematicBody2D

# constants

const JUMP_HEIGHT = 350#500
const JUMP_MOMENTUM_BOOST = 50 # how much
const JUMP_MOMENTUM_BOOST_SPEED = 200 
const WALL_JUMP_HEIGHT = 400
const WALL_JUMP_WIDTH = 250
const WALL_JUMP_MIN_HEIGHT = 200
const RUN_SPEED = 10#80
const FRICTION = 5.2#1.2#1.14
const AIR_FRICTION = 1.00
const MAX_AIR_SPEED = 200
const AIR_SPEED = 15
#const AIR_SPEED_TURN_BOOST = 7
const GRAVITY = 1900.0
const IS_PLAYER = true
const WALL_FRICTION = 2

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
var is_on_collected_cp = false #whether or not the player is on a checkpoint that is already collected. this stops checkpoints from being collected every frame you are on them
var tilemap
var instant_controls = false
#onready var hs = get_node(Gconst.HOOKSHOT_PATH)
onready var hs = get_node("hookshot")

func go_to_spawnpoint():
	position = Vector2(0,0)
# warning-ignore:return_value_discarded
#	get_tree().reload_current_scene()
	#velocity = Vector2(0,0)
	#global_position = global_position + Vector2(4,0) #= get_parent().global_position
func die():
	go_to_spawnpoint()


func get_which_wall_collided():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.normal.x > 0:
			return Gconst.LEFT
		elif collision.normal.x < 0:
			return Gconst.RIGHT
	return null

func stop_hs():
	emit_signal("stop_hs")
	hs_active = false
	hs_pulling = false
	
func jump():
	emit_signal("stop_hs")
	velocity.y = -JUMP_HEIGHT #+ -abs(velocity.x) / 3
	if abs(velocity.x) > JUMP_MOMENTUM_BOOST_SPEED:
		velocity.y += -JUMP_MOMENTUM_BOOST
	else:
		velocity.y += (velocity.y/JUMP_MOMENTUM_BOOST_SPEED)*JUMP_MOMENTUM_BOOST
	hs_active = false
	hs_pulling = false
	#if abs(velocity.x) > 
	
func get_tile_under():
	if tilemap != null:
		#print_debug("checking" + String(global_position))
		return tilemap.get_cell(global_position.x/32,global_position.y/32)
	else:
		print_debug("unable to get tilemap")
		return

func get_tile_direction(): #no transform is up
	var cx = global_position.x/32 #cell x
	var cy = global_position.y/32
	var is_transp = tilemap.is_cell_transposed(cx,cy)
	var is_x_flip = tilemap.is_cell_x_flipped(cx,cy)
	var is_y_flip = tilemap.is_cell_y_flipped(cx,cy)
#	print_debug("t:"+str(is_transp)+"\nx:"+str(is_x_flip)+"\ny:"+str(is_y_flip))
	if is_transp:
		if is_x_flip:
			return Gconst.LEFT
		else:
			return Gconst.RIGHT
	else:
#		if !is_x_flip:
		if is_y_flip: 
			return Gconst.DOWN
		else:
			return Gconst.UP
		
	
#checks for things like spikes and checkpoints
func react_to_tile():
	var tile = get_tile_under()
	if tile == Gconst.TILES["checkpoint"]:#tilemap.get_cell(global_position.x/32,global_position.y/32) == 3: # if player is on checkpoint
		get_parent().position = global_position
		if !is_on_collected_cp:
			get_parent().save_game()
			is_on_collected_cp = true
		position = Vector2(0,0)
	else:
		is_on_collected_cp = false
	
	if tile == Gconst.TILES["spikes"]:
#		print_debug(get_tile_direction())
		var tileD = get_tile_direction()
		if tileD == Gconst.UP and is_on_floor():
			die()
		elif tileD == Gconst.DOWN and is_on_ceiling():
			die()
		elif tileD == get_which_wall_collided():
			die()
# end of custom functions
	
# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = get_node(Gconst.TILEMAP_PATH)
	pass
	#print_debug(get_path())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
#func _process(delta):
#	if tilemap.get_cell(global_position.x/32,global_position.y/32) == 3: # if player is on checkpoint
#		get_parent().position = global_position
#		if !is_on_collected_cp:
#			get_parent().save_game()
#			is_on_collected_cp = true
#		position = Vector2(0,0)
#	else:
#		is_on_collected_cp = false
#	pass
	#debug
#	print_debug(velocity.x)
	#print_debug(is_on_floor())
	#print_debug(get_path())
	#/debug


# warning-ignore:unused_argument
func _physics_process(delta):
	if hs_active:
		fallspeed = 0
#	elif is_on_wall():
#		fallspeed = GRAVITY/3
	elif Input.is_action_pressed("jump"): #variable jump height and slow falling
		if timeFromGround < 0.3:
			fallspeed = GRAVITY/4
		else:
			fallspeed = GRAVITY/2
	else:
		fallspeed = GRAVITY
	
	if !hs_active or hs_pulling:
		velocity = move_and_slide(Vector2(velocity.x,velocity.y),Vector2(0,-1))
	if hs_pulling and (is_on_wall() or is_on_ceiling()):
		#stops the hookshot when you hit a wall
		hs.enter_end_slide()
		stop_hs()
	# when adding down right and down left, make sure to add them here
	elif hs_pulling and (get_node("hookshot").hs_dir == Gconst.DOWN or Gconst.DOWN_RIGHT or Gconst.DOWN_LEFT) and is_on_floor():
		hs.enter_end_slide()
		stop_hs()


	if is_on_floor():
		timeFromGround = 0
	else:
		timeFromGround += 1*delta
		
	if !hs_active: #turns off input when hookshot is active
#		if abs(velocity.x) < MAX_AIR_SPEED:
		if  Input.is_action_pressed("ui_right") and velocity.x <= MAX_AIR_SPEED:
			velocity.x += AIR_SPEED
#				if velocity.x < 50:
#				velocity.x += AIR_SPEED_TURN_BOOST			
		elif Input.is_action_pressed("ui_left") and velocity.x >= -MAX_AIR_SPEED:
			velocity.x -= AIR_SPEED
#			if velocity.x > 50:
#				velocity.x -= AIR_SPEED_TURN_BOOST
			
		if timeFromGround == 0 and hs.hs_state != hs.END_SLIDE:
			if Input.is_action_pressed("ui_right"):
				velocity.x += RUN_SPEED
			elif Input.is_action_pressed("ui_left"):
				velocity.x -= RUN_SPEED
			velocity.x = velocity.x * (1/ exp((FRICTION) * delta) )
		elif timeFromGround > 0: 
			velocity.x = velocity.x / AIR_FRICTION #* delta
		#apply gravity:
		velocity.y = velocity.y + fallspeed*delta
		
		if instant_controls:
			if Input.is_action_pressed("ui_left"):
				velocity.x = -150
			elif Input.is_action_pressed("ui_right"):
				velocity.x = 150
			else:
				velocity.x = velocity.x/2
		
		if is_on_wall() and hs.hs_state != hs.END_SLIDE: #reduce fallspeed if on a wall
			velocity.y = velocity.y / WALL_FRICTION
			
		
	if timeFromGround < 0.2:
		if Input.is_action_just_pressed("jump"):
			jump()
	# start walljump proccesing
	if is_on_wall():
		timeFromWall = 0
		lastWallDir = get_which_wall_collided()
	else:
		timeFromWall += 1*delta
		
	if timeFromWall < 0.1 and Input.is_action_just_pressed("jump") and timeFromGround != 0  :
		velocity.y -= WALL_JUMP_HEIGHT
		if lastWallDir == Gconst.RIGHT:
			velocity.x = -WALL_JUMP_WIDTH
		elif lastWallDir == Gconst.LEFT:
			velocity.x = WALL_JUMP_WIDTH
		if velocity.y > -WALL_JUMP_MIN_HEIGHT:
			velocity.y = -WALL_JUMP_MIN_HEIGHT
			
	react_to_tile()
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
	#var hs = get_node("hookshot")
	if dir == Gconst.RIGHT:
		velocity = Vector2(hs.hs_speed*2,0)
	elif dir == Gconst.LEFT:
		velocity = Vector2(-hs.hs_speed*2,0)
	elif dir == Gconst.UP:
		velocity = Vector2(0,-hs.hs_speed*2)
	elif dir == Gconst.DOWN:
		velocity = Vector2(0,hs.hs_speed*2)
	elif dir == Gconst.DOWN_RIGHT:
		velocity = Vector2(hs.hs_speed*Gconst.D_VECTOR_CO*2,hs.hs_speed*Gconst.D_VECTOR_CO*2)
	elif dir == Gconst.DOWN_LEFT:
		velocity = Vector2(-hs.hs_speed*Gconst.D_VECTOR_CO*2,hs.hs_speed*Gconst.D_VECTOR_CO*2)
	elif dir == Gconst.UP_RIGHT:
		velocity = Vector2(hs.hs_speed*Gconst.D_VECTOR_CO*2,-hs.hs_speed*Gconst.D_VECTOR_CO*2)
	elif dir == Gconst.UP_LEFT:
		velocity = Vector2(-hs.hs_speed*Gconst.D_VECTOR_CO*2,-hs.hs_speed*Gconst.D_VECTOR_CO*2)



func _on_death_plane_body_entered(body):
	if body == self:
		die()


func _on_hookshot_hs_cancel():
	hs_active = false
	hs_pulling = false
	pass # Replace with function body.
