extends Node3D

@onready var pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var blur_timer = $BlurTimer
@onready var ui = $UI
@onready var photoTimer = $PhotoTimer
@onready var cameraClick = $CameraClick



const deg90InRad = 1.5708
const mouseSensitivity : float = 0.001

enum direction {NORTH, WEST, SOUTH, EAST}
var facingDir = direction.NORTH

var gameFocused : bool = false

#camera settings
var minCamFOV = 15
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

var uiScrapbookCanvas : CanvasLayer
var uiCamCanvas : CanvasLayer
var uiMainMenuCanvas : CanvasLayer
var uiLastPhotoCanvas : CanvasLayer

var crowsAreSus : bool = false
var pigeonsAreSus : bool = false
var beesAreSus : bool = false
var skunksAreSus : bool = false

var photoToLoad : int = -1
var photoSlotsTaken : Array[int] = []

signal susPigeonPhotoTaken
signal susCrowPhotoTaken
signal susBeePhotoTaken
signal susSkunkPhotoTaken

@onready var pigeonPhotoTimer = $PigeonPhotoTimer
@onready var crowPhotoTimer = $CrowPhotoTimer
@onready var beePhotoTimer = $BeePhotoTimer
@onready var skunkPhotoTimer = $SkunkPhotoTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")
	
	dir = DirAccess.open("user://screenshots")
	for n in dir.get_files():
		screenshotCount += 1
	
	for m in dir.get_files():
		for n in range(8):
			if m.ends_with(str(n)+".png"):
				photoSlotsTaken.append(n)
	
	uiScrapbookCanvas = ui.get_child(0)
	uiCamCanvas = ui.get_child(1)
	uiMainMenuCanvas = ui.get_child(2)
	uiLastPhotoCanvas = ui.get_child(3)
	
	ui.pictureCounterLabel.text = str(screenshotCount)
	
	timer.set_wait_time(1)
	photoTimer.set_wait_time(0.2)
	
	pigeonPhotoTimer.set_wait_time(0.5)
	crowPhotoTimer.set_wait_time(0.5)
	beePhotoTimer.set_wait_time(0.5)
	skunkPhotoTimer.set_wait_time(0.5)
	
	
	InitializeCameraAttributes()
	connect("blurAmountChanged", OnBlurAmountChanged)
	connect("pictureTaken", OnPictureTaken)
	uiScrapbookCanvas.visible = false
	uiCamCanvas.visible = true
	
	ui.connect("savePhoto", OnPictureSaved)
	ui.connect("deletePhoto", OnPictureDeleted)
	ui.connect("deleteAllPhotos", OnDeleteAllPhotos)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		gameFocused = true
	

func _unhandled_input(event: InputEvent):

	if event.is_action_pressed("ui_cancel") :
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		gameFocused = false
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			pivot.rotate_y(-event.relative.x * mouseSensitivity)
			camera.rotate_x(-event.relative.y * mouseSensitivity)
			
			var lookSidewaysAngle = 30
			var lookUpAngle = 30
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
		if gameFocused and not scrapBookOpen and not uiLastPhotoCanvas.visible:
			sprite.visible = false
			uiCamCanvas.visible = false
			
			photoTimer.start()
			await photoTimer.timeout

			Screenshot()

	
	if Input.is_action_just_pressed("OpenScrapbook") and ui.lastPhotoCanvas.visible == false:

		if uiScrapbookCanvas.visible == false:
			sprite.visible = false
			uiCamCanvas.visible = false
			scrapBookOpen = true
			uiScrapbookCanvas.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			LoadAllScreenshots()
		else:
			uiScrapbookCanvas.visible = false
			sprite.visible = true
			uiCamCanvas.visible = true
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
		#var viewport = camera.get_viewport()
		#var texture = viewport.get_texture()
		#var img = texture.get_image()
		screenshotCount += 1
		cameraClick.play()
		var sussyPigeonCaptured : bool = false
		var sussyCrowCaptured : bool = false
		var sussyBeeCaptured : bool = false
		var sussySkunkCaptured :bool = false
		
		if pigeonsAreSus and facingDir == direction.NORTH:
			photoToLoad = 1
			susPigeonPhotoTaken.emit()
			pigeonPhotoTimer.start()
			sussyPigeonCaptured = true
			photoSlotsTaken.append(1)
			#img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			
		elif crowsAreSus and facingDir == direction.SOUTH:
			photoToLoad = 2
			susCrowPhotoTaken.emit()
			crowPhotoTimer.start()
			sussyCrowCaptured = true
			photoSlotsTaken.append(2)
			#img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			
		elif beesAreSus and facingDir == direction.EAST:
			photoToLoad = 3
			susBeePhotoTaken.emit()
			beePhotoTimer.start()
			sussyBeeCaptured = true
			photoSlotsTaken.append(3)
			#img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			
		elif skunksAreSus and facingDir == direction.WEST:
			photoToLoad = 4
			susSkunkPhotoTaken.emit()
			skunkPhotoTimer.start()
			sussySkunkCaptured = true
			photoSlotsTaken.append(4)

			
		elif not photoSlotsTaken.has(5):
			photoToLoad = 5
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			photoSlotsTaken.append(5)
			#img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			
		elif not photoSlotsTaken.has(6):
			photoToLoad = 6
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			photoSlotsTaken.append(6)
			#img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			
		elif not photoSlotsTaken.has(7):
			photoToLoad = 7
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			photoSlotsTaken.append(7)
			#img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			
		elif not photoSlotsTaken.has(8):
			photoToLoad = 8
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			photoSlotsTaken.append(8)
			#img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			
		if sussyPigeonCaptured:
			await pigeonPhotoTimer.timeout
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			sussyPigeonCaptured = false
			
		if sussyCrowCaptured:
			await crowPhotoTimer.timeout
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			sussyCrowCaptured = false
			
		if sussyBeeCaptured:
			await beePhotoTimer.timeout
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			sussyBeeCaptured = false
			
		if sussySkunkCaptured:
			await skunkPhotoTimer.timeout
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(photoToLoad) + ".png")
			sussySkunkCaptured = false
			
		pictureTaken.emit()

func LoadLastScreenshot():
	var image = Image.load_from_file("user://screenshots/screenshot" + str(photoToLoad) + ".png")
	#image.flip_x()
	var texture = ImageTexture.create_from_image(image)
	#texture.set_size_override(Vector2i(1,1))
	#$Sprite2D.texture = texture
	ui.setLastPhoto(texture, photoToLoad)

func LoadAllScreenshots():
	for m in photoSlotsTaken:
			
		var img = Image.load_from_file("user://screenshots/screenshot" + str(m) + ".png")
		var texture = ImageTexture.create_from_image(img)
		texture.set_size_override(screenshotSize)
		ui.setPhotoArrTexture(m-1, texture)
		
func InitializeCameraAttributes():
	camAttribs = CameraAttributesPractical.new()
	camAttribs.dof_blur_amount = 0.0
	camAttribs.dof_blur_near_enabled = true
	camAttribs.dof_blur_far_enabled = true
	camera.set_attributes(camAttribs)
	
func OnBlurAmountChanged():
	blur_timer.set_wait_time(1)
	blur_timer.start()
	await blur_timer.timeout
	camAttribs.dof_blur_amount = 0.0
	camera.set_attributes(camAttribs)
	
func OnPictureTaken():
	ui.pictureCounterLabel.text = str(screenshotCount)
	LoadLastScreenshot()
	ui.get_child(3).visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func OnPictureSaved():
	print("PHOTO SAVED")
	ui.lastPhotoIndex = photoToLoad
	
func OnPictureDeleted():
	DirAccess.remove_absolute("user://screenshots/screenshot" +str(photoToLoad)+".png")
	photoSlotsTaken.remove_at(photoSlotsTaken.find(photoToLoad))
	screenshotCount -= 1
	ui.pictureCounterLabel.text = str(screenshotCount)
	
func OnDeleteAllPhotos():
	for m in photoSlotsTaken:
		DirAccess.remove_absolute("user://screenshots/screenshot" +str(m) + ".png")
		photoSlotsTaken.clear()
		screenshotCount = 0
		ui.pictureCounterLabel.text = str(screenshotCount)
		
	
	
	pass
