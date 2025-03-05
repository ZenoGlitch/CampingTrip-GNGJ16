extends Node2D

@onready var pictureCounterLabel = $Label
var pictureCounter : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pictureCounterLabel.text = str(pictureCounter)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
