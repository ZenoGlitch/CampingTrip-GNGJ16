extends Node2D

#CANVASES
@onready var scrapbookCanvas = $ScrapbookCanvas
@onready var cameraCanvas = $CameraCanvas
@onready var mainMenuCanvas = $MainMenuCanvas
@onready var lastPhotoCanvas = $LastPhotoCanvas
@onready var endScreenCanvas = $EndScreenCanvas

#PHOTOS
@onready var photoArr : Array[Sprite2D] = [$ScrapbookCanvas/Sprite1, $ScrapbookCanvas/Sprite2, $ScrapbookCanvas/Sprite3, $ScrapbookCanvas/Sprite4, $ScrapbookCanvas/Sprite5, $ScrapbookCanvas/Sprite6, $ScrapbookCanvas/Sprite7, $ScrapbookCanvas/Sprite8]
@onready var photoArr2 : Array[Photo] = [$ScrapbookCanvas/Photo1, $ScrapbookCanvas/Photo2, $ScrapbookCanvas/Photo3, $ScrapbookCanvas/Photo4, $ScrapbookCanvas/Photo5, $ScrapbookCanvas/Photo6, $ScrapbookCanvas/Photo7, $ScrapbookCanvas/Photo8]
const maxPhotosAmount : int = 8

#SCRAPBOOK STUFF
@onready var scrapbook = $ScrapbookCanvas/Scrapbook
@onready var scrapbook2 = $ScrapbookCanvas/Scrapbook2
@onready var scrapbook3 = $ScrapbookCanvas/Scrapbook3
@onready var scrapbook4 = $ScrapbookCanvas/Scrapbook4
@onready var sprite1 = $ScrapbookCanvas/Sprite1
@onready var flipPageSound = $ScrapbookCanvas/FlipPageSound

#COLLIDERS
@onready var sb1area2d = $ScrapbookCanvas/scrapbook1Area2D
@onready var scrapbookCollider1 = $ScrapbookCanvas/scrapbook1Area2D/CollisionShape2D
@onready var sb2area2d = $ScrapbookCanvas/scraobook2Area2D
@onready var scrapbookCollider2 = $ScrapbookCanvas/scraobook2Area2D/CollisionShape2D
@onready var sb3area2d = $ScrapbookCanvas/scrapbook3Area2D
@onready var scrapbookCollider3 = $ScrapbookCanvas/scrapbook3Area2D/CollisionShape2D
@onready var sb4area2d = $ScrapbookCanvas/scrapbook4Area2D
@onready var scrapbookCollider4 = $ScrapbookCanvas/scrapbook4Area2D/CollisionShape2D

var pictureCounter : int = 0
@onready var pictureCounterLabel = $ScrapbookCanvas/Label

var currentPage : int = 1
var currentlyGrabbedPhoto : int = -1

var pigeonPicCorrect : bool = false
var crowPicCorrect : bool = false
var beePicCorrect : bool = false
var skunkPicCorrect : bool = false

@onready var lastPhoto = $LastPhotoCanvas/LastPhoto
var lastPhotoIndex = -1

signal savePhoto
signal deletePhoto
signal deleteAllPhotos
signal deleteScrapbookPhoto

# Called when the node enters the scene tree for the first time.
func _ready():
	scrapbook2.visible = false
	scrapbook3.visible = false
	scrapbook4.visible = false
	
	scrapbookCanvas.visible = false
	cameraCanvas.visible = false
	lastPhotoCanvas.visible = false
	mainMenuCanvas.visible = true
	endScreenCanvas.visible = false
	
	var newID = 0
	for m in photoArr2:
		newID += 1
		m.connect("scrapbookPhotoDeleted", OnScrapbookPhotoDeleted)
		m.connect("pictureReleased", OnPictureReleased)
		m.ID = newID
		m.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if scrapbookCanvas.visible and currentlyGrabbedPhoto != -1:
		CheckAllPicturesPlacement(currentlyGrabbedPhoto)
	
	CheckAllPicturesCorrect()
	
func setPhotoArrTexture(index : int, tex : Texture):
	photoArr2[index].sprite.texture = tex

func FlipPageLeft():
	flipPageSound.play(0.30)
	match currentPage:
		1: 
			return
		2:
			scrapbook2.visible = false
			if crowPicCorrect:
				for m in photoArr2:
					if m.isCrowPic:
						m.visible = false
			scrapbook.visible = true
			if pigeonPicCorrect:
				for m in photoArr2:
					if m.isPigeonPic:
						m.visible = true
			currentPage = 1
			
		3:
			scrapbook3.visible = false
			if beePicCorrect:
				for m in photoArr2:
					if m.isBeePic:
						m.visible = false
			scrapbook2.visible = true
			if crowPicCorrect:
				for m in photoArr2:
					if m.isCrowPic:
						m.visible = true
			currentPage = 2
			
		4:
			scrapbook4.visible = false
			if skunkPicCorrect:
				for m in photoArr2:
					if m.isSkunkPic:
						m.visible = false
			scrapbook3.visible = true
			if beePicCorrect:
				for m in photoArr2:
					if m.isBeePic:
						m.visible = true
			currentPage = 3

func FlipPageRight():
	flipPageSound.play(0.30)
	match currentPage:
		1: 
			scrapbook.visible = false
			if pigeonPicCorrect:
				for m in photoArr2:
					if m.isPigeonPic:
						m.visible = false
			scrapbook2.visible = true
			
			if crowPicCorrect:
				for m in photoArr2:
					if m.isCrowPic:
						m.visible = true
			currentPage = 2
			
		2:
			scrapbook2.visible = false
			if crowPicCorrect:
				for m in photoArr2:
					if m.isCrowPic:
						m.visible = false
			scrapbook3.visible = true
			
			if beePicCorrect:
				for m in photoArr2:
					if m.isBeePic:
						m.visible = true
			currentPage = 3
			
		3:
			scrapbook3.visible = false
			if beePicCorrect:
				for m in photoArr2:
					if m.isBeePic:
						m.visible = false
			scrapbook4.visible = true
			
			if skunkPicCorrect:
				for m in photoArr2:
					if m.isSkunkPic:
						m.visible = true
			currentPage = 4
			
		4:
			return

func CheckOverlap(grabbedPhoto : int, area : Area2D, collider : CollisionShape2D):
	var spriteLeftX = photoArr2[grabbedPhoto].position.x - (photoArr2[grabbedPhoto].sprite.texture.get_width() / 2)
	var spriteRightX = photoArr2[grabbedPhoto].position.x + (photoArr2[grabbedPhoto].sprite.texture.get_width() / 2)
	var spriteTopY = photoArr2[grabbedPhoto].position.y - (photoArr2[grabbedPhoto].sprite.texture.get_height() / 2)
	var spriteBottomY = photoArr2[grabbedPhoto].position.y + (photoArr2[grabbedPhoto].sprite.texture.get_height() / 2)
	
	var collider1LeftX = area.position.x - (collider.shape.size.x / 2)
	var collider1RightX = area.position.x + (collider.shape.size.x / 2)
	var collider1TopY = area.position.y - (collider.shape.size.y / 2)
	var collider1BottomY = area.position.y + (collider.shape.size.y / 2)

	if spriteLeftX > collider1LeftX and spriteRightX < collider1RightX and spriteTopY > collider1TopY and spriteBottomY < collider1BottomY:
		return true
	else:
		return false

func CheckAllPicturesPlacement(grabbedPhoto : int):
	match currentPage:
		1:
			if photoArr2[grabbedPhoto].isPigeonPic:
				if CheckOverlap(grabbedPhoto, sb1area2d, scrapbookCollider1):
					photoArr2[grabbedPhoto].allowedToMove = false
					pigeonPicCorrect = true
		2:
			if photoArr2[grabbedPhoto].isCrowPic:
				if CheckOverlap(grabbedPhoto, sb2area2d, scrapbookCollider2):
					photoArr2[grabbedPhoto].allowedToMove = false
					crowPicCorrect = true
		3:
			if photoArr2[grabbedPhoto].isBeePic:
				if CheckOverlap(grabbedPhoto, sb3area2d, scrapbookCollider3):
					photoArr2[grabbedPhoto].allowedToMove = false
					beePicCorrect = true
		4:
			if photoArr2[grabbedPhoto].isSkunkPic:
				if CheckOverlap(grabbedPhoto, sb4area2d, scrapbookCollider4):
					photoArr2[grabbedPhoto].allowedToMove = false
					skunkPicCorrect = true

func CheckAllPicturesCorrect():
	if pigeonPicCorrect and crowPicCorrect and beePicCorrect and skunkPicCorrect:
		scrapbookCanvas.visible = false
		endScreenCanvas.visible = true
	
func setLastPhoto(tex : ImageTexture, idx : int):
	tex.set_size_override(Vector2(1600, 900))
	lastPhoto.texture = tex
	lastPhotoIndex = idx

func ungrabOtherPhotos(photoArrIdx : int):
	for i in photoArr2:
		if i == photoArr2[photoArrIdx]:
			continue
		else:
			i.grabbed = false

#region UI BUTTONS
func _on_start_game_button_pressed():
	mainMenuCanvas.visible = false
	cameraCanvas.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_flip_page_left_button_pressed():
	FlipPageLeft()
	
func _on_flip_page_right_button_pressed():
	FlipPageRight()
	
func _on_save_photo_button_pressed():
	var tex = lastPhoto.texture
	tex.set_size_override(Vector2(384,216))
	savePhoto.emit()
	photoArr2[lastPhotoIndex-1].sprite.texture = tex
	photoArr2[lastPhotoIndex-1].visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	lastPhotoCanvas.visible = false
	cameraCanvas.visible = true

func _on_delete_photo_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pictureCounter -= 1
	lastPhotoCanvas.visible = false
	cameraCanvas.visible = true
	deletePhoto.emit(lastPhotoIndex)

func _on_quit_game_button_pressed():
	get_tree().quit()
	
func _on_delete_all_photos_button_pressed():
	deleteAllPhotos.emit()
	#var tex = load("res://Assets/transparentPlaceholder.png")
	for m in photoArr2:
		m.fullyResetPhoto()
		
#endregion


#region PHOTO SIGNAL CONNECTIONS
func OnScrapbookPhotoDeleted(ID):
	deleteScrapbookPhoto.emit(ID)
func OnPictureReleased():
	currentlyGrabbedPhoto = -1

func _on_photo_1_picture_grabbed():
	currentlyGrabbedPhoto = 0
	ungrabOtherPhotos(currentlyGrabbedPhoto)
	
func _on_photo_2_picture_grabbed():
	currentlyGrabbedPhoto = 1
	ungrabOtherPhotos(currentlyGrabbedPhoto)
	
func _on_photo_3_picture_grabbed():
	currentlyGrabbedPhoto = 2
	ungrabOtherPhotos(currentlyGrabbedPhoto)

func _on_photo_4_picture_grabbed():
	currentlyGrabbedPhoto = 3
	ungrabOtherPhotos(currentlyGrabbedPhoto)
	
func _on_photo_5_picture_grabbed():
	currentlyGrabbedPhoto = 4
	ungrabOtherPhotos(currentlyGrabbedPhoto)
	
func _on_photo_6_picture_grabbed():
	currentlyGrabbedPhoto = 5
	ungrabOtherPhotos(currentlyGrabbedPhoto)

func _on_photo_7_picture_grabbed():
	currentlyGrabbedPhoto = 6
	ungrabOtherPhotos(currentlyGrabbedPhoto)
	
func _on_photo_8_picture_grabbed():
	currentlyGrabbedPhoto = 7
	ungrabOtherPhotos(currentlyGrabbedPhoto)
#endregion
