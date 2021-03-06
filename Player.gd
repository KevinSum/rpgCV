extends KinematicBody2D

# Contants
const STEP_SIZE = 16 # size of tiles, so we need how many pixels the player needs to move
const MOVEMENT_SPEED = 2 # Speed of movement


# Variables
var player_pos = Vector2() # Current coordinate position of player
var end_pos = Vector2() # Destination coordinate when arrow key is pressed 
var direction = Vector2() # Direction of movement
var world # World
var animationPlayer
var sprite
var footstep

var player_vel = Vector2() # Current velocity of player
var moving = false  # Check if already moving
var canMove = true # Check if player is able to move (Can't when in dialogue)
var interactPressed = false # Check if intereact button is pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_world_2d().get_direct_space_state()
	set_process_input(true)
	animationPlayer = get_node("AnimationPlayer")
	sprite = get_node("PlayerSprite")
	footstep = get_node("Footstep Sound")
	
func _input(event):
	if event.is_action_pressed("ui_interact"):
		interactPressed = true
	elif event.is_action_released("ui_interact"):
		interactPressed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_pos = get_global_position() # Get current position
	
	## MOVEMENT ##
	if !moving and canMove:
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
				
		## INTERACT WITH PEOPLE
		elif interactPressed: # Interact key
			animationPlayer.seek(0, true) # Reset Animation Player to idle frame
			animationPlayer.stop(true) # Stop Animation Player
			if direction == Vector2(0, -1): # Check which direction we're facing (Up)
				end_pos = player_pos + Vector2(0, 0 - STEP_SIZE) # Find co-ordinates tile we're facing
			elif direction == Vector2(0, 1): # Down
				end_pos = player_pos + Vector2(0, 0 + STEP_SIZE)
			elif direction == Vector2(-1, 0): # Left
				end_pos = player_pos + Vector2(0 - STEP_SIZE, 0)
			elif direction == Vector2(1, 0): # Right
				end_pos = player_pos + Vector2(STEP_SIZE, 0)
			var dictionary = world.intersect_point(end_pos + Vector2(8, 8)) # Get dictionary of ray query (n.b. offset (8.8) to get to collision area as opposed to corner)
			if dictionary: # If there is a collision thing in the direction we're facing
				interact(dictionary)
				
		elif canMove: #When not moving, but can move (not interacting)
			moving = false
			animationPlayer.seek (0, true) # Reset Animation Player to idle frame
			animationPlayer.stop (true) # Stop Animation Player
				
	interactPressed = false # Ensure bool is only active for one frame

	if moving:
		if sprite.frame % 4 == 2 and !footstep.is_playing(): # Play footstep sound on "step" frame
			footstep.play()
		move_and_collide(direction * MOVEMENT_SPEED) # Move player a little every frame
		player_pos = get_global_position() # Check current position	
		if player_pos == end_pos: # Stop if goal position has been reached
			moving = false
			
func interact(dictionary):
	for d in dictionary: 
		if typeof(d.collider) == TYPE_OBJECT and d.collider.has_node("Interact"):
			get_node("Camera2D/Dialogue Box").set_visible(true) # Make dialogue box visible
			get_node("Camera2D/Dialogue Box")._print_dialogue(d.collider.get_node("Interact").text) 
			# If interacting with sprite, change direction that the sprite is facing
			var interactedNode = d.collider.get_node("..")
			if d.collider.has_node("Turn"):
				if direction == Vector2(0, -1): # Check which direction we're facing (Up)
					interactedNode.set_frame(0)  # Set frame of the sprite that we're interating with to face us (Face down)
				elif direction == Vector2(0, 1): # Down
					interactedNode.set_frame(2) 
				elif direction == Vector2(-1, 0): # Left
					interactedNode.set_frame(3) 
				elif direction == Vector2(1, 0): # Right
					interactedNode.set_frame(1) 
