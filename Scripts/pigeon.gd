extends Node3D

@onready var pigeon1 = $Pigeon1
@onready var pigeon2 = $Pigeon2

var rng = RandomNumberGenerator.new()

var my_array = [0, 1]
var weights = PackedFloat32Array([2, 0.2])

signal pigeonsAreSus

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
		pigeon1.set_frame(0)
		pigeon1.set_flip_h(true)
		pigeon2.set_frame(0)
		sussyPhotoCaptured = false
		updateTimer.start()
	
	await updateTimer.timeout
	var randomNr = my_array[rng.rand_weighted(weights)]
	
	pigeon1.set_frame(randomNr)
	pigeon2.set_frame(randomNr)
	
	if pigeon1.get_frame() == 0 or pigeon1.get_frame() == 2:
		pigeon1.set_flip_h(true)
	elif pigeon1.get_frame() == 1:
		pigeon1.set_flip_h(false)
	
	if pigeon1.get_frame() == 1 and pigeon2.get_frame() == 1:
		#pigeonsAreSus.emit(true)
		Global.pigeonsAreSus = true
	else:
		#pigeonsAreSus.emit(false)
		Global.pigeonsAreSus = false

	updateTimer.start()
