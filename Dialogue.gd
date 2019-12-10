extends NinePatchRect

# Declare member variables here. Examples:
var printing = false # check if text is being printed atm
var timer = 0
var textToPrint = ""

var currentChar = 0 # Character number in text

const SPEED = 0.1 # Speed to text printing

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if printing:
		timer += delta
		if timer >= SPEED: # Time to print another character
			timer = 0
			get_node("RichTextLabel").set_bbcode(get_node("RichTextLabel").get_bbcode() + textToPrint[currentChar]) # Append previous text with new text with another character in text
			currentChar += 1
		if currentChar >= textToPrint.length(): # Stop printing when entire text has been printed
			currentChar = 0
			printing = false
			textToPrint = ""
			timer = 0
			

func _print_dialogue(text):
	printing = true
	textToPrint = text
