extends Node3D

@onready var camera = $Camera3D


const deg90InRad = 1.5708


var target 
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(InputEvent):
	if Input.is_action_just_pressed("TurnLeft"):
		RotateLeft()
		
	if Input.is_action_just_pressed("TurnRight"):
		RotateRight()
		
	if Input.is_action_just_pressed("TakePhoto"):
		print("Neeerp")
		pass
	
	
func RotateLeft():
	self.rotate_y(deg90InRad)
	
func RotateRight():
	self.rotate_y(-deg90InRad)
	
