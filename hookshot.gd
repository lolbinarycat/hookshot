extends Position2D

const MAX_RANGE = 800
const MAX_TIME = 1.5
const MIN_SPEED = 140
const START_WINDOW_TIME = 0.08#5/60.0
const HS_THROW_FRIC = 3
const END_SLIDE_DURATION = 0.1

signal hs_extend #sent when the hookshot enters the extention state
signal hs_miss #sent when the hookshot retracts without hitting anything
signal hs_cancel #sent when the hookshot is canceled WHILE PULLING THE PLAYER
#signal hs_pull # snt wh/ hs pulls player

enum {INACTIVE,EXTENDING,RETRACTING,PULLING,STARTING,END_SLIDE} #pulling = hookshot hit a wall
var hs_state = INACTIVE #what is the hookshot doing
var hs_dist = 0.0 #how far is the end of the hookshot away from the player
var hs_dir
var hs_dir_buffer = 0.0 #timer for how long you have to press a button after using the hookshot
var hs_speed = 0.0
var hs_time = 0.0
var hs_start_window = 0.0 #START_WINDOW_TIME
var end_slide_timer = 0.0
var player

func get_direction():
	if Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_down"):
			return Gconst.DOWN_LEFT
		elif Input.is_action_pressed("ui_up"):
			return Gconst.UP_LEFT
		return Gconst.LEFT
	elif Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("ui_down"):
			return Gconst.DOWN_RIGHT
		elif Input.is_action_pressed("ui_up"):
			return Gconst.UP_RIGHT
		return Gconst.RIGHT
	elif Input.is_action_pressed("ui_up"):
		return Gconst.UP
	elif Input.is_action_pressed("ui_down"):
		return Gconst.DOWN

# warning-ignore:unused_argument
func start_hs(delta):
	hs_state = EXTENDING
	if hs_dir == Gconst.RIGHT: #you transfer your momentum into the hookshot
		hs_speed = (get_parent().velocity.x )
	elif hs_dir == Gconst.LEFT:
		hs_speed = (-get_parent().velocity.x )
	elif hs_dir == Gconst.UP:
		hs_speed = (-get_parent().velocity.y )
	elif hs_dir == Gconst.DOWN:
		hs_speed = (get_parent().velocity.y )
	elif hs_dir == Gconst.DOWN_RIGHT:
		hs_speed = (get_parent().velocity.y + get_parent().velocity.x)
	elif hs_dir == Gconst.DOWN_LEFT:
		hs_speed = (player.velocity.y + -player.velocity.x)
	elif hs_dir == Gconst.UP_RIGHT:
		hs_speed = (-player.velocity.y + player.velocity.x)
	elif hs_dir == Gconst.UP_LEFT:
		hs_speed = (-player.velocity.y + -player.velocity.x)
	
	hs_speed = (hs_speed / HS_THROW_FRIC) + MIN_SPEED
	
	if hs_speed <= MIN_SPEED:
		hs_speed = MIN_SPEED
	emit_signal("hs_extend")
	hs_time = 0
	
func do_state(delta):
	if hs_state == EXTENDING:
		hs_dist += hs_speed*delta
		hs_time += delta
	elif hs_state == RETRACTING:
		hs_dist += -hs_speed*delta
	elif hs_state == PULLING:
		hs_dist += (-hs_speed*delta)
	elif hs_state == STARTING:
		hs_start_window -= delta
	elif hs_state == END_SLIDE:
		end_slide_timer -= delta
		if end_slide_timer < 0:
			hs_state = INACTIVE
			
			
func update_hs_position():
	if hs_dir == Gconst.RIGHT: #decide where to put hs head based on orientation and distance
		position.x = hs_dist
	elif hs_dir == Gconst.LEFT:
		position.x = -hs_dist
	elif hs_dir == Gconst.UP:
		position.y = -hs_dist
		position.x = 0
	elif hs_dir == Gconst.DOWN:
		position.y = hs_dist
	elif hs_dir == Gconst.DOWN_RIGHT:
		position.x = hs_dist*Gconst.D_VECTOR_CO
		position.y = hs_dist*Gconst.D_VECTOR_CO
	elif hs_dir == Gconst.DOWN_LEFT:
		position.x = -hs_dist*Gconst.D_VECTOR_CO
		position.y = hs_dist*Gconst.D_VECTOR_CO
	elif hs_dir == Gconst.UP_RIGHT:
		position = Vector2(hs_dist*Gconst.D_VECTOR_CO,-hs_dist*Gconst.D_VECTOR_CO)
	elif hs_dir == Gconst.UP_LEFT:
		position = Vector2(-hs_dist*Gconst.D_VECTOR_CO,-hs_dist*Gconst.D_VECTOR_CO)

func enter_end_slide():
	hs_state = END_SLIDE
	end_slide_timer = END_SLIDE_DURATION

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	pass # Replace with function body.
	#print_debug(5/60.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("hookshot"):
		if hs_state == INACTIVE:
			hs_state = STARTING
			hs_start_window = START_WINDOW_TIME
		elif hs_state == EXTENDING:
			hs_state = RETRACTING
		elif hs_state == PULLING:
			print_debug("pull canceled")
			hs_state = INACTIVE
			hs_dist = 0
			emit_signal("hs_cancel")

	do_state(delta)
		
	if hs_state == STARTING and hs_start_window <= 0:
		hs_dir = get_direction()
		if hs_dir != null:
			hs_state = EXTENDING
			start_hs(delta)

	if hs_dist <= 0: # what happens when the hookshot is retracted
		if hs_state == RETRACTING:
			emit_signal("hs_miss") #deceptive name
			hs_state = INACTIVE
		if hs_state == PULLING:
#			print_debug("END_SLIDE state set")
			hs_state = INACTIVE
			end_slide_timer = END_SLIDE_DURATION
	elif hs_dist > MAX_RANGE:
		hs_state = RETRACTING
	elif hs_time > MAX_TIME:
		hs_state = RETRACTING
		
	if hs_state == INACTIVE:
		hs_dist = 0
		position = Vector2(0,0)
		hs_speed = 0
		hs_time = MAX_TIME
	elif hs_state == STARTING:
		if hs_start_window <= 0:
			hs_state = INACTIVE
	
	update_hs_position()
	
#	pass


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_hookshot_head_hs_hit(dir):
	#print_debug("hs state set to retract")
	if hs_state == EXTENDING:
		hs_state = PULLING


func _on_Player_stop_hs():
#	print_debug("signal recived")
	if hs_state != END_SLIDE:
		hs_state = INACTIVE
	hs_dist = 0
