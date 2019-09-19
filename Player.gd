extends KinematicBody2D

# Contants
const STEP_SIZE = 16 # size of tiles, so we need how many pixels the player needs to move
#const STEP_TIME = 5 # Number of frames it takes to move Player across one tile
const MOVEMENT_SPEED = 1 # Speed of movement

# Variables
var player_pos = Vector2() # Current coordinate position of player
var end_pos = Vector2() # Destination coordinate when arrow key is pressed 
var direction = Vector2() # Direction of movement
var world # World

var player_vel = Vector2() # Current velocity of player
var moving = false  # Check if already moving

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_world_2d().get_direct_space_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	player_pos = get_global_position() # Get current position
	
	# Maybe check end_pos!= player_pos, but player_pos tends to go over end_pos, since delta is discrete. Maybe use velocity * delta and 
	# calculate remaining distance remaining
	if !moving:
		## MOVEMENT ##
		if Input.is_action_pressed("ui_left"):
			if world.intersect_point(player_pos + Vector2(0 - STEP_SIZE, 0)).empty():
				direction = Vector2(-1, 0)
				end_pos = player_pos + Vector2(0 - STEP_SIZE, 0)
				moving = true
		elif Input.is_action_pressed("ui_right"):
			if world.intersect_point(player_pos + Vector2(STEP_SIZE, 0)).empty():
				direction = Vector2(1, 0)
				end_pos = player_pos + Vector2(STEP_SIZE, 0)
				moving = true
		elif Input.is_action_pressed("ui_up"):
			if world.intersect_point(player_pos + Vector2(0, 0 - STEP_SIZE)).empty():
				direction = Vector2(0, -1)
				end_pos = player_pos + Vector2(0, 0 - STEP_SIZE)
				moving = true
		elif Input.is_action_pressed("ui_down"):
			if world.intersect_point(player_pos + Vector2(0, 0 + STEP_SIZE)).empty():
				direction = Vector2(0, 1)
				end_pos = player_pos + Vector2(0, 0 + STEP_SIZE)
				moving = true
		else:
#			if (int(player_pos.x) % STEP_SIZE == 0) or (int(player_pos.y) % STEP_SIZE == 0) :
#				player_vel = Vector2(0,0)
			moving = false

	if moving:
		move_and_collide(direction * MOVEMENT_SPEED) # Move player
		player_pos = get_global_position() 
		if player_pos == end_pos:
			moving = false
	#move_and_collide(player_vel) # Move player
	

	
