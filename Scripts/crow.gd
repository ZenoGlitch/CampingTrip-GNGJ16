extends Node3D

@onready var crow1 = $crow1
@onready var crow2 = $crow2

var rng = RandomNumberGenerator.new()

var my_array = [0, 1]
var weights = PackedFloat32Array([2, 0.2])

signal crowsAreSus

@onready var updateTimer = $UpdateTimer
@onready var animationTimer = $AnimationTimer

var doneOnce : bool = false

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
		crow1.set_frame(0)
		crow2.set_frame(0)
		sussyPhotoCaptured = false
		updateTimer.start()
		
	
	await updateTimer.timeout
	var randomNr = my_array[rng.rand_weighted(weights)]
	crow1.set_frame(randomNr)
	crow2.set_frame(randomNr)
	
	if crow1.get_frame() == 1 and crow2.get_frame() == 1:
		#crowsAreSus.emit(true)
		Global.crowsAreSus = true
	else:
		#crowsAreSus.emit(false)
		Global.crowsAreSus = false

	updateTimer.start()
		
	
