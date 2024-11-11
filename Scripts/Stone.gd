extends RigidBody2D

var thrown = false
var moving = false
const SLIDING_DAMPING = 0.4
const STOP_VELOCITY_THRESHOLD = 5

func _ready():
	self.gravity_scale = 0
	self.mass = 20
	linear_damp = SLIDING_DAMPING

func throw_stone(direction: Vector2, power: float):
	# Apply an initial velocity to the stone based on direction and power
	self.thrown = true
	self.moving = true
	linear_velocity = direction.normalized() * power
	print("Stone velocity: ", linear_velocity)

func _process(delta):
	if self.moving and self.linear_velocity.length() < STOP_VELOCITY_THRESHOLD:
		self.moving = false
