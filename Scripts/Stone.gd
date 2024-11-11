extends RigidBody2D

const LINEAR_DAMPENING = 0.996
const STOP_VELOCITY_THRESHOLD = 5
const sweepImpact = 120

var thrown = false
var moving = false
var initial_velocity: Vector2

func _ready():
	self.gravity_scale = 0
	self.mass = 20

func throw_stone(direction: Vector2, power: float):
	# Apply an initial velocity to the stone based on direction and power
	self.thrown = true
	self.moving = true
	linear_velocity = direction.normalized() * power
	initial_velocity = linear_velocity
	print("Stone velocity: ", linear_velocity)

func _process(delta):
	var current_speed = self.linear_velocity.length()
	if current_speed > STOP_VELOCITY_THRESHOLD:
		# Diminish curl impact based on current speed relative to initial velocity
		var curl_factor = current_speed / initial_velocity.length()
		var scaled_sweep_impact = sweepImpact * curl_factor
		
		# Apply reduced curling force if left or right input is pressed
		if Input.is_action_pressed("ui_left"):
			self.linear_velocity.x -= scaled_sweep_impact * delta  # Apply small impulse over time
		elif Input.is_action_pressed("ui_right"):
			self.linear_velocity.x += scaled_sweep_impact * delta  # Apply small impulse over time
		
		# Gradually reduce the stone's overall speed for a more natural stop
		self.linear_velocity *= LINEAR_DAMPENING

	# Stop the stone if it has slowed to below the stop threshold
	if self.moving and current_speed < STOP_VELOCITY_THRESHOLD:
		self.moving = false
		self.linear_velocity = Vector2.ZERO  # Ensure it fully stops
