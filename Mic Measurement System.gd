extends AudioStreamPlayer2D
# Also does the animation for the mic side

# Declare member variables here. Examples:
var micAnimationPlayer # Node of the animation of the mic
var mic_pos = 0 # Index to determine direction of mic (0 = up, 1 = right, 2 = down, 3 = left
var sweepPlayed = false # Check if sine sweep has been played for a position yet

# Called when the node enters the scene tree for the first time.
func _ready():
	micAnimationPlayer = get_node("../../../Mic/AnimationPlayer")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	micAnimationPlayer = get_node("../../../Mic/AnimationPlayer")
	
	var pos_diff = get_node("..").get_global_position() # Get position of the sprite that this audio node is associated with
	set_global_position(pos_diff) # Change pos of where the audio is coming from
	
	# Play sweep if not done for a mic position yet
	if !sweepPlayed and !micAnimationPlayer.is_playing():
		play()
		sweepPlayed = true
	
	# Turn mic once sweep has been player
	if !micAnimationPlayer.is_playing() and !is_playing():
		# Determine animation to based on where mic needs to turn
		if mic_pos == 0:
			micAnimationPlayer.play("Turn Right")
		elif mic_pos == 1:
			micAnimationPlayer.play("Turn Down")
		elif mic_pos == 2:
			micAnimationPlayer.play("Turn Left")
		elif mic_pos == 3:
			micAnimationPlayer.play("Turn Up")

		mic_pos += 1 # Increment to update mic position
		if mic_pos > 3:# Wrap index
			mic_pos = 0
		
		sweepPlayed = false
		
