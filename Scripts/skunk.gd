extends Node3D

@onready var skunk = $AnimatedSprite3D

var rng = RandomNumberGenerator.new()

var my_array = [0, 1]
var weights = PackedFloat32Array([2, 0.2])

signal skunksAreSus

@onready var updateTimer = $UpdateTimer
@onready var animationTimer = $AnimationTimer

var sussyPhotoCaptured : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	updateTimer.set_wait_time(1.0)
	animationTimer.set_wait_time(0.5)
	updateTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if sussyPhotoCaptured:
		updateTimer.stop()
		animationTimer.start()
		await animationTimer.timeout
		skunk.set_frame(0)
		sussyPhotoCaptured = false
		updateTimer.start()
	
	await updateTimer.timeout
	var randomNr = my_array[rng.rand_weighted(weights)]
	skunk.set_frame(randomNr)
	
	if skunk.get_frame() == 1:
		#skunksAreSus.emit(true)
		Global.skunksAreSus = true
	else:
		#skunksAreSus.emit(false)
		Global.skunksAreSus = false

	updateTimer.start()
	
