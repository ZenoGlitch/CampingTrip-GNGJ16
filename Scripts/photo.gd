extends Sprite2D

var grabbed : bool = false
var mouseOffset : Vector2 = Vector2(0, 0)
signal pictureGrabbed
signal pictureReleased

var allowedToMove : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if grabbed and allowedToMove:
		followMouse()

func _input(event):
	if Input.is_action_just_pressed("TakePhoto") and $"..".visible and self.texture.resource_path != "res://Assets/transparentPlaceholder.png":
		if get_rect().has_point(to_local(event.position)):
			mouseOffset = position - get_global_mouse_position()
			grabbed = true
			pictureGrabbed.emit()
	if Input.is_action_just_released("TakePhoto"):
		grabbed = false
		pictureReleased.emit()

func followMouse():
	position = get_global_mouse_position() + mouseOffset
	pass
	
