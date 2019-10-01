extends KinematicBody2D

# Contants
const STEP_SIZE = 16 # size of tiles, so we need how many pixels the player needs to move
const MOVEMENT_SPEED = 1 # Speed of movement

# Variables
var player_pos = Vector2() # Current coordinate position of player
var end_pos = Vector2() # Destination coordinate when arrow key is pressed 
var direction = Vector2() # Direction of movement
var world # World
var animationPlayer
var sprite

var player_vel = Vector2() # Current velocity of player
var moving = false  # Check if already moving

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_world_2d().get_direct_space_state()
	animationPlayer = get_node("AnimationPlayer")
	sprite = get_node("Sprite")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_pos = get_global_position() # Get current position
	
	## MOVEMENT ##
	if !moving:
		if Input.is_action_pressed("ui_left"):
			animationPlayer.play("left")
			direction = Vector2(-1, 0)
			end_pos = player_pos + Vector2(0 - STEP_SIZE, 0)
			if !test_move(Transform2D(0, player_pos), end_pos - player_pos): # Check if there will be a collision when moving goal position
				moving = true
		elif Input.is_action_pressed("ui_right"):
			animationPlayer.play("right")
			direction = Vector2(1, 0)
			end_pos = player_pos + Vector2(STEP_SIZE, 0)
			if !test_move(Transform2D(0, player_pos), end_pos - player_pos):
				moving = true
		elif Input.is_action_pressed("ui_up"):
			animationPlayer.play("up")
			direction = Vector2(0, -1)
			end_pos = player_pos + Vector2(0, 0 - STEP_SIZE)
			if !test_move(Transform2D(0, player_pos), end_pos - player_pos):
				moving = true
		elif Input.is_action_pressed("ui_down"):
			animationPlayer.play("down")
			direction = Vector2(0, 1)
			end_pos = player_pos + Vector2(0, 0 + STEP_SIZE)
			if !test_move(Transform2D(0, player_pos), end_pos - player_pos):
				moving = true
		else:
			moving = false
			if sprite.get_frame() % 3  == 0:
				animationPlayer.stop(true)

	if moving:
		move_and_collide(direction * MOVEMENT_SPEED) # Move player a little every frame
		player_pos = get_global_position() # Check current position	
		if player_pos == end_pos: # Stop if goal position has been reached
			moving = false