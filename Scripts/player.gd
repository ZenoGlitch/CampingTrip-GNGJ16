extends Node3D

@onready var pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var blur_timer = $BlurTimer
@onready var ui = $UI
@onready var photoTimer = $PhotoTimer

const deg90InRad = 1.5708
const mouseSensitivity : float = 0.001

enum direction {NORTH, WEST, SOUTH, EAST}
var facingDir = direction.NORTH

var gameFocused : bool = false

#camera settings
var minCamFOV = 40
var maxCamFOV = 75
const camZoomSpeed : float = 1.0
var camAttribs : CameraAttributesPractical
const blurAmount : float = 0.05

#signals
signal blurAmountChanged
signal pictureTaken

var screenshotCount : int = 0

var scrapBookOpen : bool = false
const screenshotSize : Vector2i = Vector2i(384,216)

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")
	
	dir = DirAccess.open("user://screenshots")
	for n in dir.get_files():
		screenshotCount += 1
	
	ui.pictureCounterLabel.text = str(screenshotCount)
	
	timer.set_wait_time(1)
	photoTimer.set_wait_time(0.2)
	
	InitializeCameraAttributes()
	connect("blurAmountChanged", OnBlurAmountChanged)
	connect("pictureTaken", OnPictureTaken)
	var uiCanvas = ui.get_child(0)
	uiCanvas.visible = false
	var uiCanvas2 = ui.get_child(1)
	uiCanvas2.visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	pass

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and not scrapBookOpen:
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
			
			var lookSidewaysAngle = 30
			var lookUpAngle = 15
			var lookDownAngle = 30
			
			pivot.rotation.y = clamp(pivot.rotation.y, deg_to_rad(-lookSidewaysAngle), deg_to_rad(lookSidewaysAngle))
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-lookDownAngle), deg_to_rad(lookUpAngle))

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("TurnLeft"):
		RotateLeft()
		
	if Input.is_action_just_pressed("TurnRight"):
		RotateRight()
		
	if Input.is_action_just_pressed("ZoomIn"):
		if camera.fov > minCamFOV:
			camera.fov -= camZoomSpeed
			camAttribs.dof_blur_amount = blurAmount
			camera.set_attributes(camAttribs)
			blurAmountChanged.emit()
	
	if Input.is_action_just_pressed("ZoomOut"):
		if camera.fov < maxCamFOV:
			camera.fov += camZoomSpeed
			camAttribs.dof_blur_amount = blurAmount
			camera.set_attributes(camAttribs)
			blurAmountChanged.emit()
			
	if Input.is_action_just_pressed("TakePhoto"):
		if gameFocused and not scrapBookOpen:
			sprite.visible = false
			var uiCanvas2 = ui.get_child(1)
			uiCanvas2.visible = false
			
			photoTimer.start()
			await photoTimer.timeout
			Screenshot()
	
	if Input.is_action_just_pressed("OpenScrapbook"):
		var uiCanvas = ui.get_child(0)
		var uiCanvas2 = ui.get_child(1)
		
		if uiCanvas.visible == false:
			uiCanvas2.visible = false
			scrapBookOpen = true
			uiCanvas.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			LoadAllScreenshots()
		else:
			uiCanvas.visible = false
			uiCanvas2.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			scrapBookOpen = false
	
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
	if screenshotCount <= 7:
		var viewport = camera.get_viewport()
		var texture = viewport.get_texture()
		var img = texture.get_image()
		screenshotCount += 1
		img.save_png("user://screenshots/screenshot" + str(screenshotCount) + ".png")
		pictureTaken.emit()
		photoTimer.start()
		await photoTimer.timeout
		sprite.visible = true
		var uiCanvas2 = ui.get_child(1)
		uiCanvas2.visible = true

func LoadLastScreenshot():
	var image = Image.load_from_file("user://screenshots/screenshot" + str(screenshotCount) + ".png")
	image.flip_x()
	var texture = ImageTexture.create_from_image(image)
	texture.set_size_override(Vector2i(1,1))
	$Sprite2D.texture = texture

func LoadAllScreenshots():
	for n in range(screenshotCount):
		var img = Image.load_from_file("user://screenshots/screenshot" +str(n+1) + ".png")
		var texture = ImageTexture.create_from_image(img)
		texture.set_size_override(screenshotSize)
		
		ui.setPhotoArrTexture(n, texture)
		
func InitializeCameraAttributes():
	camAttribs = CameraAttributesPractical.new()
	camAttribs.dof_blur_amount = 0.0
	camAttribs.dof_blur_near_enabled = true
	camAttribs.dof_blur_far_enabled = true
	camera.set_attributes(camAttribs)
	
func OnBlurAmountChanged():
	blur_timer.set_wait_time(0.5)
	blur_timer.start()
	await blur_timer.timeout
	camAttribs.dof_blur_amount = 0.0
	camera.set_attributes(camAttribs)
	
func OnPictureTaken():
	ui.pictureCounterLabel.text = str(screenshotCount)
	LoadLastScreenshot()
	
