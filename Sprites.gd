extends Sprite

# Declare member variables here.
var sprite_node_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	setZpos(self)
	pass

# Set Z pos of nodes relative of Player node, depending on if they're above or below
func setZpos(node):
	for N in node.get_children():
		if N.get_class() == "Sprite":
			var sprite_pos = N.get_global_position()
			var player_node = get_node("Player")
			var player_pos = player_node.get_global_position()
			if sprite_pos.y > player_pos.y: # Note: Some sprites shouldn't change Z pos
				N.set_z_index(2)
			else:
				N.set_z_index(0)
