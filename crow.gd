extends Node3D

@onready var crow1 = $crow1
@onready var crow2 = $crow2

var rng = RandomNumberGenerator.new()

var my_array = [0, 1]
var weights = PackedFloat32Array([2, 0.2])

signal crowsAreSus

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(1.0)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await timer.timeout
	var randomNr = my_array[rng.rand_weighted(weights)]
	crow1.set_frame(randomNr) 
	crow2.set_frame(randomNr)
	
	if crow1.frame == 1 and crow2.frame == 1:
		crowsAreSus.emit()
	
