extends Position2D

const MAX_RANGE = 800
const MAX_TIME = 1
const MIN_SPEED = 1

signal hs_extend #sent when the hookshot enters the extention state
signal hs_miss #sent when the hookshot retracts without hitting anything
#signal hs_pull # snt wh/ hs pulls player

enum {INACTIVE,EXTENDING,RETRACTING,PULLING} #pulling = hookshot hit a wall
var hs_state = INACTIVE #what is the hookshot doing
var hs_dist = 0 #how far is the end of the hookshot away from the player
enum {LEFT,RIGHT,UP,DOWN}
var hs_dir 
var hs_dir_buffer = 0.0 #timer for how long you have to press a button after using the hookshot
var hs_speed
var hs_time = 0.0

func get_direction():
	if Input.is_action_pressed("ui_left"):
		return LEFT
	elif Input.is_action_pressed("ui_right"):
		return RIGHT
	elif Input.is_action_pressed("ui_up"):
		return UP

func start_hs(delta):
	hs_state = EXTENDING
	if hs_dir == RIGHT: #you transfer your momentum into the hookshot
		hs_speed = (get_parent().velocity.x + MIN_SPEED) * delta
	elif hs_dir == LEFT:
		hs_speed = (-get_parent().velocity.x + MIN_SPEED) * delta
	elif hs_dir == UP:
		hs_speed = (get_parent().velocity.y + MIN_SPEED) * delta
	if hs_speed <= MIN_SPEED:
		hs_speed = MIN_SPEED	
	emit_signal("hs_extend")
	hs_time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("hookshot"):
		if hs_state == INACTIVE:
			hs_dir = get_direction()
			if hs_dir != null:
				start_hs(delta)
			else:
				hs_dir_buffer = 5
		elif hs_state == EXTENDING:
			hs_state = RETRACTING
	if Input.is_action_pressed("hookshot") and hs_dir_buffer > 0:
		hs_dir = get_direction()
		if hs_dir == null:
			hs_dir_buffer -= delta
		else:
			hs_state = EXTENDING
			start_hs(delta)
			hs_dir_buffer = 0
	if hs_state == EXTENDING:
		hs_dist += hs_speed
		hs_time += delta
	elif hs_state == RETRACTING:
		hs_dist += -hs_speed
	elif hs_state == PULLING:
		hs_dist += (-Gconst.HS_PULL_SPEED*delta)
		#get_parent().position.x -= HS_PULL_SPEED
	
	if hs_dist <= 0: # what happens when the hookshot is retracted
		if hs_state == RETRACTING:
			emit_signal("hs_miss") #deceptive name
		hs_state = INACTIVE
	elif hs_dist > MAX_RANGE:
		hs_state = RETRACTING
	elif hs_time > MAX_TIME:
		hs_state = RETRACTING
		
	if hs_dir == RIGHT: #decide where to put hs head based on orientation and distance 
		position.x = hs_dist
	elif hs_dir == LEFT:
		position.x = -hs_dist
	elif hs_dir == UP:
		position.y = -hs_dist
		position.x = 0
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
	hs_state = INACTIVE
	hs_dist = 0
