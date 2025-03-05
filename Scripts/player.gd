extends Node3D

@onready var pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D
@onready var sprite = $Sprite2D
@onready var timer = $Timer

const deg90InRad = 1.5708
const mouseSensitivity : float = 0.001

enum direction {NORTH, WEST, SOUTH, EAST}
var facingDir = direction.NORTH

var gameFocused : bool = false

var minCamFOV = 40
var maxCamFOV = 75
const camZoomSpeed : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	pass

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if not gameFocused:
			timer.start()
			await timer.timeout
			gameFocused = true
			
		
	elif event.is_action_pressed("ui_cancel") :
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		gameFocused = false
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			pivot.rotate_y(-event.relative.x * mouseSensitivity)
			camera.rotate_x(-event.relative.y * mouseSensitivity)
			pivot.rotation.y = clamp(pivot.rotation.y, deg_to_rad(-30), deg_to_rad(30))
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(30))
		if event is InputEventMouseButton and gameFocused:
			Screenshot()
			LoadScreenshot()
	
	

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("TurnLeft"):
		RotateLeft()
		
	if Input.is_action_just_pressed("TurnRight"):
		RotateRight()
		
	if Input.is_action_just_pressed("ZoomIn"):
		if camera.fov > minCamFOV:
			camera.fov -= camZoomSpeed
			
	
	if Input.is_action_just_pressed("ZoomOut"):
		if camera.fov < maxCamFOV:
			camera.fov += camZoomSpeed
		
	#if Input.is_action_just_pressed("TakePhoto"):
		#Screenshot()
		#LoadScreenshot()
	
func RotateLeft():
	self.rotate_y(deg90InRad)
	match facingDir:
		direction.NORTH:
			facingDir = direction.WEST
		direction.WEST:
			facingDir = direction.SOUTH
		direction.SOUTH:
			facingDir = direction.EAST
		direction.EAST:
			facingDir = direction.NORTH
	
func RotateRight():
	self.rotate_y(-deg90InRad)
	match facingDir:
		direction.NORTH:
			facingDir = direction.EAST
		direction.WEST:
			facingDir = direction.NORTH
		direction.SOUTH:
			facingDir = direction.WEST
		direction.EAST:
			facingDir = direction.SOUTH

func Screenshot():
	var viewport = camera.get_viewport()
	var texture = viewport.get_texture()
	var img = texture.get_image()
	img.save_png("user://activeImage.png")
	
func LoadScreenshot():
	var image = Image.load_from_file("user://activeImage.png")
	image.flip_x()
	var texture = ImageTexture.create_from_image(image)
	texture.set_size_override(Vector2i(1,1))
	$Sprite2D.texture = texture
	
	
