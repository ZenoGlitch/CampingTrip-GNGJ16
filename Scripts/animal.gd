extends Node3D

@onready var animated_sprite_3d = $AnimatedSprite3D
var messageSent : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_3d.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animated_sprite_3d.frame == 2 and not messageSent:
		print("squawk!")
		messageSent = true
	elif animated_sprite_3d.frame == 1 and messageSent:
		messageSent = false
	pass
