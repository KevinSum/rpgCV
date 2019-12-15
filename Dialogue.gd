extends NinePatchRect

# Declare member variables here. Examples:
var printing = false # check if text is being printed atm
var donePrinting = false

var pressed = false

var timer = 0
var textToPrint = []

var currentText = 0 # Index indicated which bit of text/which array we're on
var currentChar = 0 # Which character in the text we're on

var voiceAudio 

const SPEED = 0.01 # Speed to text printing

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	set_process_unhandled_key_input(true) # Allow internal processing
	voiceAudio = get_node("VoiceAudio")

	
func _unhandled_key_input(key_event):
	if key_event.is_action_pressed("ui_interact"):
		pressed = true
		
	elif key_event.is_action_released("ui_interact"):
		pressed = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if printing:
		if !donePrinting:
			timer += delta
			if timer >= SPEED: # Time to print another character
				timer = 0
				# Append previous text with same text but with another character
				get_node("RichTextLabel").set_bbcode(get_node("RichTextLabel").get_bbcode() + textToPrint[currentText][currentChar]) 
				currentChar += 1 # Index for next character
				if !voiceAudio.playing: # Check is audio file is currently playing
					voiceAudio.play() # Play voice audio
			if currentChar >= textToPrint[currentText].length(): # Stop printing when entire text has been printed
				currentChar = 0 # Start from the first character on the next text we're printing (after the the button is pressed in function below)
				timer = 0
				donePrinting = true
				currentText += 1 # Go to next bit of text
		elif pressed: # Move into next bit of dialogue 
			donePrinting = false
			get_node("RichTextLabel").set_bbcode("")
			if currentText >= textToPrint.size(): # If we've reached last bit of text
				currentText = 0
				textToPrint = []
				printing = false
				set_visible(false)
				get_node("/root/Map/Sprites/Player").canMove = true
				
	pressed = false

func _print_dialogue(text):
	printing = true
	textToPrint = text
	get_node("/root/Map/Sprites/Player").canMove = false
