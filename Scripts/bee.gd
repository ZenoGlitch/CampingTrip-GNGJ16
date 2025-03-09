extends Node3D

@onready var bee1 = $Bee1
@onready var bee2 = $Bee2

var rng = RandomNumberGenerator.new()

var my_array = [0, 1]
var weights = PackedFloat32Array([2, 0.2])

signal beesAreSus

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
		bee1.set_frame(0)
		bee1.set_flip_h(true)
		bee2.set_frame(0)
		sussyPhotoCaptured = false
		updateTimer.start()
	
	await updateTimer.timeout
	var randomNr = my_array[rng.rand_weighted(weights)]
	if bee1.is_flipped_h():
		bee1.set_flip_h(false)
	bee1.set_frame(randomNr)
	bee2.set_frame(randomNr)
	
	if bee1.get_frame() == 1 and bee2.get_frame() == 1:
		beesAreSus.emit(true)
	else:
		beesAreSus.emit(false)

	updateTimer.start()
