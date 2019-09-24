extends Label

# Declare member variables here
var player_pos = Vector2()
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_pos = get_node("..").player_pos
	set_text(String(player_pos))

	pass
