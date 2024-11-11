extends Node

const POWER_MULTIPLIER = 5.0  # Adjust as needed for the throw power

var game_controller: Node  # Reference to the GameController
var drag_start_position: Vector2
var is_dragging: bool = false
var stone: RigidBody2D

# Function to assign the stone dynamically
func set_stone(stone_instance: RigidBody2D, game_controller_instance: Node):
	stone = stone_instance
	game_controller = game_controller_instance
	print("Stone assigned: ", stone)

func _input(event):
	# Handle touch start and mouse click start
	if (
		# Touchscreen
		(event is InputEventScreenTouch and event.pressed) 
		# Mouse
		or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT)
	):
		# Check if the drag is starting near the stone's position
		if stone and stone.global_position.distance_to(event.position) < 50:  # Adjust distance threshold as needed
			is_dragging = true
			drag_start_position = event.position
			print("Throw started at: ", drag_start_position)
	
	# Handle touch end and mouse release
	elif (
		# Touchscreen
		(event is InputEventScreenTouch and not event.pressed and is_dragging) 
		# Mouse
		or (event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and is_dragging)
	):
		# When the drag is released, calculate direction and power, and throw the stone
		is_dragging = false
		var drag_end_position = event.position
		print("Throw ended at: ", drag_end_position)
		_release(drag_start_position, drag_end_position)

func _release(start_pos: Vector2, end_pos: Vector2):
	# Check the direction and power
	var direction = start_pos.direction_to(end_pos)*-1
	var power = start_pos.distance_to(end_pos) * POWER_MULTIPLIER
	print("Stone direction: ", direction)
	# Call the throw_stone function on the stone
	if stone:
		stone.throw_stone(direction, power)
