extends Node3D

@onready var player = $Player
@onready var animal = $Animal

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello GN!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	toggleAnimalAnimation()
	pass
	
func toggleAnimalAnimation():
	if player.facingDir == player.direction.NORTH:
		animal.animated_sprite_3d.play()
	else:
		animal.animated_sprite_3d.stop()
