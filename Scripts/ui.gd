extends Node2D

#CANVASES
@onready var scrapbookCanvas = $ScrapbookCanvas
@onready var cameraCanvas = $CameraCanvas
@onready var mainMenuCanvas = $MainMenuCanvas
@onready var lastPhotoCanvas = $LastPhotoCanvas
@onready var endScreenCanvas = $EndScreenCanvas

#PHOTOS
@onready var photoArr : Array[Sprite2D] = [$ScrapbookCanvas/Sprite1, $ScrapbookCanvas/Sprite2, $ScrapbookCanvas/Sprite3, $ScrapbookCanvas/Sprite4, $ScrapbookCanvas/Sprite5, $ScrapbookCanvas/Sprite6, $ScrapbookCanvas/Sprite7, $ScrapbookCanvas/Sprite8]

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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	CheckFullOverlap(currentlyGrabbedPhoto)
	CheckAllPicturesCorrect()
	
func setPhotoArrTexture(index : int, tex : Texture):
	photoArr[index].texture = tex

func _on_flip_page_left_button_pressed():
	FlipPageLeft()
	
func _on_flip_page_right_button_pressed():
	FlipPageRight()

func FlipPageLeft():
	flipPageSound.play(0.30)
	match currentPage:
		1: 
			return
		2:
			scrapbook2.visible = false
			if crowPicCorrect:
				photoArr[1].visible = false
			scrapbook.visible = true
			if pigeonPicCorrect:
				photoArr[0].visible = true
			currentPage = 1
			
		3:
			scrapbook3.visible = false
			if beePicCorrect:
				photoArr[2].visible = false
			scrapbook2.visible = true
			if crowPicCorrect:
				photoArr[1].visible = true
			currentPage = 2
			
		4:
			scrapbook4.visible = false
			if skunkPicCorrect:
				photoArr[3].visible = false
			scrapbook3.visible = true
			if beePicCorrect:
				photoArr[2].visible = true
			currentPage = 3
			

func FlipPageRight():
	flipPageSound.play(0.30)
	match currentPage:
		1: 
			scrapbook.visible = false
			if pigeonPicCorrect:
				photoArr[0].visible = false
			scrapbook2.visible = true
			if crowPicCorrect:
				photoArr[1].visible = true
			currentPage = 2
			
		2:
			scrapbook2.visible = false
			if crowPicCorrect:
				photoArr[1].visible = false
			scrapbook3.visible = true
			if beePicCorrect:
				photoArr[2].visible = true
			currentPage = 3
			
		3:
			scrapbook3.visible = false
			if beePicCorrect:
				photoArr[2].visible = false
			scrapbook4.visible = true
			if skunkPicCorrect:
				photoArr[3].visible = true
			currentPage = 4
			
		4:
			return

func CheckFullOverlap(grabbedPhoto : int):
	
	match grabbedPhoto:
		-1:
			return
		0:
			if currentPage == 1:
				var spriteLeftX = photoArr[grabbedPhoto].position.x - (photoArr[grabbedPhoto].texture.get_width() / 2)
				var spriteRightX = photoArr[grabbedPhoto].position.x + (photoArr[grabbedPhoto].texture.get_width() / 2)
				var spriteTopY = photoArr[grabbedPhoto].position.y - (photoArr[grabbedPhoto].texture.get_height() / 2)
				var spriteBottomY = photoArr[grabbedPhoto].position.y + (photoArr[grabbedPhoto].texture.get_height() / 2)
				
				var collider1LeftX = sb1area2d.position.x - (scrapbookCollider1.shape.size.x / 2)
				var collider1RightX = sb1area2d.position.x + (scrapbookCollider1.shape.size.x / 2)
				var collider1TopY = sb1area2d.position.y - (scrapbookCollider1.shape.size.y / 2)
				var collider1BottomY = sb1area2d.position.y + (scrapbookCollider1.shape.size.y / 2)
				if spriteLeftX > collider1LeftX and spriteRightX < collider1RightX and spriteTopY > collider1TopY and spriteBottomY < collider1BottomY:
					pigeonPicCorrect = true
				else:
					pigeonPicCorrect = false
		1:
			if currentPage == 2:
				var spriteLeftX = photoArr[grabbedPhoto].position.x - (photoArr[grabbedPhoto].texture.get_width() / 2)
				var spriteRightX = photoArr[grabbedPhoto].position.x + (photoArr[grabbedPhoto].texture.get_width() / 2)
				var spriteTopY = photoArr[grabbedPhoto].position.y - (photoArr[grabbedPhoto].texture.get_height() / 2)
				var spriteBottomY = photoArr[grabbedPhoto].position.y + (photoArr[grabbedPhoto].texture.get_height() / 2)
				
				var collider1LeftX = sb2area2d.position.x - (scrapbookCollider2.shape.size.x / 2)
				var collider1RightX = sb2area2d.position.x + (scrapbookCollider2.shape.size.x / 2)
				var collider1TopY = sb2area2d.position.y - (scrapbookCollider2.shape.size.y / 2)
				var collider1BottomY = sb2area2d.position.y + (scrapbookCollider2.shape.size.y / 2)

				if spriteLeftX > collider1LeftX and spriteRightX < collider1RightX and spriteTopY > collider1TopY and spriteBottomY < collider1BottomY:
					crowPicCorrect = true
				else:
					crowPicCorrect = false
		2:
			if currentPage == 3:
				var spriteLeftX = photoArr[grabbedPhoto].position.x - (photoArr[grabbedPhoto].texture.get_width() / 2)
				var spriteRightX = photoArr[grabbedPhoto].position.x + (photoArr[grabbedPhoto].texture.get_width() / 2)
				var spriteTopY = photoArr[grabbedPhoto].position.y - (photoArr[grabbedPhoto].texture.get_height() / 2)
				var spriteBottomY = photoArr[grabbedPhoto].position.y + (photoArr[grabbedPhoto].texture.get_height() / 2)
				
				var collider1LeftX = sb3area2d.position.x - (scrapbookCollider3.shape.size.x / 2)
				var collider1RightX = sb3area2d.position.x + (scrapbookCollider3.shape.size.x / 2)
				var collider1TopY = sb3area2d.position.y - (scrapbookCollider3.shape.size.y / 2)
				var collider1BottomY = sb3area2d.position.y + (scrapbookCollider3.shape.size.y / 2)

				if spriteLeftX > collider1LeftX and spriteRightX < collider1RightX and spriteTopY > collider1TopY and spriteBottomY < collider1BottomY:
					beePicCorrect = true
				else:
					beePicCorrect = false
					
		3:
			if currentPage == 4:
				var spriteLeftX = photoArr[grabbedPhoto].position.x - (photoArr[grabbedPhoto].texture.get_width() / 2)
				var spriteRightX = photoArr[grabbedPhoto].position.x + (photoArr[grabbedPhoto].texture.get_width() / 2)
				var spriteTopY = photoArr[grabbedPhoto].position.y - (photoArr[grabbedPhoto].texture.get_height() / 2)
				var spriteBottomY = photoArr[grabbedPhoto].position.y + (photoArr[grabbedPhoto].texture.get_height() / 2)
				
				var collider1LeftX = sb4area2d.position.x - (scrapbookCollider4.shape.size.x / 2)
				var collider1RightX = sb4area2d.position.x + (scrapbookCollider4.shape.size.x / 2)
				var collider1TopY = sb4area2d.position.y - (scrapbookCollider4.shape.size.y / 2)
				var collider1BottomY = sb4area2d.position.y + (scrapbookCollider4.shape.size.y / 2)

				if spriteLeftX > collider1LeftX and spriteRightX < collider1RightX and spriteTopY > collider1TopY and spriteBottomY < collider1BottomY:
					skunkPicCorrect = true
				else:
					skunkPicCorrect = false

func CheckAllPicturesCorrect():
	if pigeonPicCorrect and crowPicCorrect and beePicCorrect and skunkPicCorrect:
		endScreenCanvas.visible = true
	
func setLastPhoto(tex : ImageTexture, idx : int):
	tex.set_size_override(Vector2(1600, 900))
	lastPhoto.texture = tex
	lastPhotoIndex = idx


#SPRITE SIGNAL CONNECTIONS	
func _on_sprite_1_picture_grabbed():
	currentlyGrabbedPhoto = 0
	if pigeonPicCorrect:
		photoArr[currentlyGrabbedPhoto].allowedToMove = false
	for s in photoArr:
		if s == photoArr[currentlyGrabbedPhoto]:
			continue
		else:
			s.grabbed = false

func _on_sprite_1_picture_released():
	currentlyGrabbedPhoto = -1

func _on_sprite_2_picture_grabbed():
	currentlyGrabbedPhoto = 1
	if crowPicCorrect:
		photoArr[currentlyGrabbedPhoto].allowedToMove = false
	for s in photoArr:
		if s == photoArr[currentlyGrabbedPhoto]:
			continue
		else:
			s.grabbed = false

func _on_sprite_2_picture_released():
	currentlyGrabbedPhoto = -1

func _on_sprite_3_picture_grabbed():
	currentlyGrabbedPhoto = 2
	if beePicCorrect:
		photoArr[currentlyGrabbedPhoto].allowedToMove = false
	for s in photoArr:
		if s == photoArr[currentlyGrabbedPhoto]:
			continue
		else:
			s.grabbed = false

func _on_sprite_3_picture_released():
	currentlyGrabbedPhoto = -1

func _on_sprite_4_picture_grabbed():
	currentlyGrabbedPhoto = 3
	if skunkPicCorrect:
		photoArr[currentlyGrabbedPhoto].allowedToMove = false
	for s in photoArr:
		if s == photoArr[currentlyGrabbedPhoto]:
			continue
		else:
			s.grabbed = false

func _on_sprite_4_picture_released():
	currentlyGrabbedPhoto = -1

func _on_start_game_button_pressed():
	mainMenuCanvas.visible = false
	cameraCanvas.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_save_photo_button_pressed():
	var tex = lastPhoto.texture
	tex.set_size_override(Vector2(384,216))
	savePhoto.emit()
	photoArr[lastPhotoIndex-1].texture = lastPhoto.texture
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	lastPhotoCanvas.visible = false
	cameraCanvas.visible = true

func _on_delete_photo_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pictureCounter -= 1
	lastPhotoCanvas.visible = false
	cameraCanvas.visible = true
	deletePhoto.emit()

func _on_quit_game_button_pressed():
	get_tree().quit()
