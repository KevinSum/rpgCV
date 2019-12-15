extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _process(delta):
	#setZpos(self)
	pass

# Set Z pos of nodes relative of Player node, depending on if they're above or below
#func setZpos(node):
#	var sprite_pos = N.get_global_position()
#	var player_node = get_node("Player")
#	var player_pos = player_node.get_global_position()
#	if sprite_pos.y > player_pos.y:
#		N.set_z_index(2)
#	else:
#		N.set_z_index(0)