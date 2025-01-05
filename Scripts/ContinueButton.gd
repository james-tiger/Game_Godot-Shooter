extends Button

# Called when the node enters the scene tree for the first time
func _ready():
	# Connect the "pressed" signal to the _on_button_pressed function
	self.pressed.connect(self._on_button_pressed)

# Function to handle the button press
func _on_button_pressed():
	# If the game is paused, resume it
	if get_tree().paused:
		get_tree().paused = false  # Resume the game
		# Optionally, hide the mouse when the game is resumed
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		# If the game is not paused, pause it
		get_tree().paused = true   # Pause the game
		# Optionally, show the mouse when the game is paused
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
