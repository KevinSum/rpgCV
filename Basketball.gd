extends AudioStreamPlayer2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos_diff = get_node("..").get_global_position() # Get position of the sprite that this audio node is associated with
	set_global_position(pos_diff) # Change pos of where the audio is coming from
	
	if get_node("..").get_frame() == 4 and !is_playing():
		play()
	pass
