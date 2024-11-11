extends Node

@export var team1_color = Color.HOT_PINK  # Red color
@export var team2_color = Color.AQUA  # Blue color

const STONES_PER_TEAM = 3
const HOUSE = Vector2(424, 360)  # Example target position
const HOUSE_RADIUS = 300

var current_team = 1  # 1 for team 1, 2 for team 2
var team1_stones = []
var team2_stones = []
var team1_stone_index = 0  # Track which stone is being thrown by team 1
var team2_stone_index = 0  # Track which stone is being thrown by team 2
var stones_thrown = 0
var player: Node  # Reference to the player node
var stone: RigidBody2D

# Initialize the game state
func _ready():
	player = $Player  # Assuming the player node is a child of GameController
	pregame()

func pregame():
	# Spawn 3 stones for each team and store them in respective lists
	var s
	for i in range(STONES_PER_TEAM):
		s = preload("res://Scenes/Stone.tscn").instantiate()
		s.modulate = team1_color  # Color stone for team 1
		s.set_position(Vector2(28, 1616))
		team1_stones.append(s)
		add_child(s)

		s = preload("res://Scenes/Stone.tscn").instantiate()
		s.modulate = team2_color  # Color stone for team 2
		s.set_position(Vector2(800, 1616))
		team2_stones.append(s)
		add_child(s)

	print(team1_stones)
	print(team2_stones)

	# Start the first turn
	start_turn()

func start_turn():	
	if current_team == 1:
		stone = team1_stones[team1_stone_index]
		team1_stone_index += 1
	else:
		stone = team2_stones[team2_stone_index]
		team2_stone_index += 1
	
	stone.global_transform.origin = Vector2(424, 1616)  # Starting position for the stone	
	
	# Dynamically assign the stone to the player
	player.set_stone(stone, self) 
	print("Team", current_team, " to throw stone")

func end_turn():
	# Switch teams and check for end of round
	stones_thrown += 1
	if stones_thrown >= STONES_PER_TEAM * 2:
		calculate_scores()
	else:
		# Reset the stone position for the next player
		current_team = 1 if current_team == 2 else 2  # Alternate between team 1 and team 2
		start_turn()

func calculate_scores():
	var team1_score = 0
	var team2_score = 0
	
	# Track distances from each stone to the target position
	var team1_distances = []
	var team2_distances = []
	
	# Calculate distances for team 1 stones within the house
	for stone in team1_stones:
		var dist = stone.global_position.distance_to(HOUSE)
		if dist <= HOUSE_RADIUS:  # Stone is in or touching the house
			team1_distances.append(dist)

	# Calculate distances for team 2 stones within the house
	for stone in team2_stones:
		var dist = stone.global_position.distance_to(HOUSE)
		if dist <= HOUSE_RADIUS:  # Stone is in or touching the house
			team2_distances.append(dist)
	
	# Sort distances for easier comparison
	team1_distances.sort()
	team2_distances.sort()
	
	# Determine scoring stones
	var i = 0
	while i < team1_distances.size() and i < team2_distances.size():
		if team1_distances[i] < team2_distances[i]:
			team1_score += 1
		elif team2_distances[i] < team1_distances[i]:
			team2_score += 1
		else:
			break  # If a stone from both teams is equally close, no more points can be scored
		i += 1

	# If one team's distances are exhausted first, award points for remaining stones in the other team
	team1_score += team1_distances.size() - i
	team2_score += team2_distances.size() - i

	# Output results
	if team1_score > team2_score:
		print("Team 1 wins with ", team1_score, " points!")
	elif team2_score > team1_score:
		print("Team 2 wins with ", team2_score, " points!")
	else:
		print("It's a draw!")

# Check for the stone's velocity each frame to see if it has stopped
func _process(delta):
	if stone and not stone.moving and stone.thrown:
		end_turn()