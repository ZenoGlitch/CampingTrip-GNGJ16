extends Node3D

@onready var pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D
#@onready var sprite = $Sprite2D
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

var screenshotCount : int = 0 :
	set(value) : 
		screenshotCount = value
		clamp(screenshotCount, 0, 8)
		if screenshotCount == 8:
			ui.memoryFullWarningLabel.show()
		else :
			ui.memoryFullWarningLabel.hide()
	get() : 
		return screenshotCount

var scrapBookOpen : bool = false
const screenshotSize : Vector2i = Vector2i(384,216)

var uiScrapbookCanvas : CanvasLayer
var uiCamCanvas : CanvasLayer
var uiMainMenuCanvas : CanvasLayer
var uiLastPhotoCanvas : CanvasLayer

#var crowsAreSus : bool = false
#var pigeonsAreSus : bool = false
#var beesAreSus : bool = false
#var skunksAreSus : bool = false

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
@onready var sussyPhotoTimer = $SussyPhotoTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")
	
	dir = DirAccess.open("user://screenshots")
	for n in dir.get_files():
		screenshotCount += 1
	
	for m in dir.get_files():
		for n in range(8):
			if m.ends_with(str(n+1)+".png"):
				photoSlotsTaken.append(n+1)
			
	LoadAllScreenshots()
	
	for p in ui.photoArr2:
		if p.sprite.texture != p.placeHolderTexture:
			p.visible = true
	
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
	
	sussyPhotoTimer.set_wait_time(0.5)
	
	InitializeCameraAttributes()
	connect("blurAmountChanged", OnBlurAmountChanged)
	connect("pictureTaken", OnPictureTaken)
	uiScrapbookCanvas.visible = false
	uiCamCanvas.visible = true
	
	ui.connect("savePhoto", OnPictureSaved)
	ui.connect("deletePhoto", OnPictureDeleted)
	ui.connect("deleteAllPhotos", OnDeleteAllPhotos)
	ui.connect("deleteScrapbookPhoto", OnDeleteScrapbookPhoto)
	
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
			#sprite.visible = false
			uiCamCanvas.visible = false
			
			photoTimer.start()
			await photoTimer.timeout

			Screenshot()

	
	if Input.is_action_just_pressed("OpenScrapbook") and ui.lastPhotoCanvas.visible == false and ui.mainMenuCanvas.visible == false:

		if uiScrapbookCanvas.visible == false:
			#sprite.visible = false
			uiCamCanvas.visible = false
			scrapBookOpen = true
			uiScrapbookCanvas.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			LoadAllScreenshots()
		else:
			uiScrapbookCanvas.visible = false
			#sprite.visible = true
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
		screenshotCount += 1
		cameraClick.play()
		var sussyPigeonCaptured : bool = false
		var sussyCrowCaptured : bool = false
		var sussyBeeCaptured : bool = false
		var sussySkunkCaptured :bool = false
			
		var idx : int = -1
		for m in ui.photoArr2:
			if m.photoSlotOccupied == false:
				idx = m.ID - 1
				m.photoSlotOccupied = true
				break
			else:
				continue
		
		photoSlotsTaken.append(idx + 1)
		
		#This line is only here to ensure that the star amount is actually reset, but should be done already before this point.
		ui.photoArr2[idx].starsAmount = 0
		
		if Global.pigeonsAreSus and facingDir == direction.NORTH:
			susPigeonPhotoTaken.emit()
			sussyPhotoTimer.start()
			ui.photoArr2[idx].isPigeonPic = true
			ui.photoArr2[idx].starsAmount += 1
			sussyPigeonCaptured = true

		if Global.crowsAreSus and facingDir == direction.SOUTH:
			susCrowPhotoTaken.emit()
			sussyPhotoTimer.start()
			ui.photoArr2[idx].isCrowPic = true
			ui.photoArr2[idx].starsAmount += 1
			sussyCrowCaptured = true

		if Global.beesAreSus and facingDir == direction.EAST:
			susBeePhotoTaken.emit()
			sussyPhotoTimer.start()
			ui.photoArr2[idx].isBeePic = true
			ui.photoArr2[idx].starsAmount += 1
			sussyBeeCaptured = true

		if Global.skunksAreSus and facingDir == direction.WEST:
			susSkunkPhotoTaken.emit()
			sussyPhotoTimer.start()
			ui.photoArr2[idx].isSkunkPic = true
			ui.photoArr2[idx].starsAmount += 1
			sussySkunkCaptured = true
			
		if camAttribs.dof_blur_amount == 0.0:
			ui.photoArr2[idx].starsAmount += 1
		if camera.fov < 30 :
			ui.photoArr2[idx].starsAmount += 1
		
		if sussyPigeonCaptured or sussyCrowCaptured or sussyBeeCaptured or sussySkunkCaptured:
			await sussyPhotoTimer.timeout
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(idx + 1) + ".png")
			ui.photoArr2[idx].visible = true
			photoToLoad = idx + 1
		else:
			var viewport = camera.get_viewport()
			var texture = viewport.get_texture()
			var img = texture.get_image()
			img.save_png("user://screenshots/screenshot" + str(idx + 1) + ".png")
			ui.photoArr2[idx].visible = true
			photoToLoad = idx + 1
			
		pictureTaken.emit()

func LoadLastScreenshot():
	var image = Image.load_from_file("user://screenshots/screenshot" + str(photoToLoad) + ".png")
	var texture = ImageTexture.create_from_image(image)
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
	#print("PHOTO SAVED")
	ui.lastPhotoIndex = photoToLoad
	
func OnPictureDeleted(photoToDelete : int):
	ui.photoArr2[photoToDelete -1].visible = false
	ui.photoArr2[photoToDelete -1].fullyResetPhoto()
	
	DirAccess.remove_absolute("user://screenshots/screenshot" +str(photoToDelete)+".png")
	photoSlotsTaken.remove_at(photoSlotsTaken.find(photoToDelete))
	screenshotCount -= 1
	ui.pictureCounterLabel.text = str(screenshotCount)
	
func OnDeleteScrapbookPhoto(photoToDelete : int):
	ui.photoArr2[photoToDelete -1].visible = false
	ui.photoArr2[photoToDelete -1].fullyResetPhoto()
	
	DirAccess.remove_absolute("user://screenshots/screenshot" +str(photoToDelete)+".png")
	photoSlotsTaken.remove_at(photoSlotsTaken.find(photoToDelete))
	screenshotCount -= 1
	ui.pictureCounterLabel.text = str(screenshotCount)
	
func OnDeleteAllPhotos():
	for n in ui.photoArr2:
		n.fullyResetPhoto()
		
	for m in photoSlotsTaken:
		DirAccess.remove_absolute("user://screenshots/screenshot" +str(m) + ".png")
	
		
	photoSlotsTaken.clear()
	screenshotCount = 0
	ui.pictureCounterLabel.text = str(screenshotCount)
