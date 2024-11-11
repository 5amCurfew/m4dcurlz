extends Node

# This function is called when the node enters the scene tree for the first time.
func _ready():
	# Connect button signals to functions in this script.
	$StartButton.connect("pressed", _on_start_button_pressed)
	$QuitButton.connect("pressed", _on_quit_button_pressed)

# Function for Start Button
func _on_start_button_pressed():
	# Load the Game scene when the Start button is pressed
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

# Function for Quit Button
func _on_quit_button_pressed():
	# Quit the application
	get_tree().quit()
