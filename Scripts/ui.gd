extends Node2D

@onready var scrapbookCanvasLayer = $CanvasLayer
@onready var cameraCanvasLayer = $CanvasLayer2


@onready var pictureCounterLabel = $CanvasLayer/Label
@onready var photoArr : Array[Sprite2D] = [$CanvasLayer/Sprite1, $CanvasLayer/Sprite2, $CanvasLayer/Sprite3, $CanvasLayer/Sprite4, $CanvasLayer/Sprite5, $CanvasLayer/Sprite6, $CanvasLayer/Sprite7, $CanvasLayer/Sprite8]
@onready var scrapbook = $CanvasLayer/Scrapbook
@onready var scrapbook2 = $CanvasLayer/Scrapbook2
@onready var scrapbook3 = $CanvasLayer/Scrapbook3
@onready var scrapbook4 = $CanvasLayer/Scrapbook4
@onready var sprite1 = $CanvasLayer/Sprite1

#COLLIDERS
@onready var sb1area2d = $CanvasLayer/scrapbook1Area2D
@onready var scrapbookCollider1 = $CanvasLayer/scrapbook1Area2D/CollisionShape2D

@onready var sb2area2d = $CanvasLayer/scraobook2Area2D
@onready var scrapbookCollider2 = $CanvasLayer/scraobook2Area2D/CollisionShape2D

@onready var sb3area2d = $CanvasLayer/scrapbook3Area2D
@onready var scrapbookCollider3 = $CanvasLayer/scrapbook3Area2D/CollisionShape2D

@onready var sb4area2d = $CanvasLayer/scrapbook4Area2D
@onready var scrapbookCollider4 = $CanvasLayer/scrapbook4Area2D/CollisionShape2D


var pictureCounter : int = 0

var currentPage : int = 1
var currentlyGrabbedPhoto : int = -1

var pigeonPicCorrect : bool = false
var crowPicCorrect : bool = false
var beePicCorrect : bool = false
var skunkPicCorrect : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pictureCounterLabel.text = str(pictureCounter)
	scrapbook2.visible = false
	scrapbook3.visible = false
	scrapbook4.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	CheckFullOverlap(currentlyGrabbedPhoto)

	
func setPhotoArrTexture(index : int, tex : Texture):
	photoArr[index].texture = tex

func _on_flip_page_left_button_pressed():
	#TODO: add page flip here
	#also make sure that pictures places on the correct pages disappear when switching to a different page
	FlipPageLeft()
	
func _on_flip_page_right_button_pressed():
	#TODO: add page flip here
	#also make sure that pictures places on the correct pages disappear when switching to a different page
	FlipPageRight()

func FlipPageLeft():
	match currentPage:
		1: 
			return
		2:
			scrapbook2.visible = false
			scrapbook.visible = true
			currentPage = 1
		3:
			scrapbook3.visible = false
			scrapbook2.visible = true
			currentPage = 2
		4:
			scrapbook4.visible = false
			scrapbook3.visible = true
			currentPage = 3

func FlipPageRight():
	match currentPage:
		1: 
			scrapbook.visible = false
			scrapbook2.visible = true
			currentPage = 2
		2:
			scrapbook2.visible = false
			scrapbook3.visible = true
			currentPage = 3
		3:
			scrapbook3.visible = false
			scrapbook4.visible = true
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
	
#SPRITE SIGNAL CONNECTIONS	
func _on_sprite_1_picture_grabbed():
	currentlyGrabbedPhoto = 0
	for s in photoArr:
		if s == photoArr[currentlyGrabbedPhoto]:
			continue
		else:
			s.grabbed = false
	CheckFullOverlap(currentlyGrabbedPhoto)

func _on_sprite_1_picture_released():
	currentlyGrabbedPhoto = -1

func _on_sprite_2_picture_grabbed():
	currentlyGrabbedPhoto = 1
	for s in photoArr:
		if s == photoArr[currentlyGrabbedPhoto]:
			continue
		else:
			s.grabbed = false

func _on_sprite_2_picture_released():
	currentlyGrabbedPhoto = -1

func _on_sprite_3_picture_grabbed():
	currentlyGrabbedPhoto = 2
	for s in photoArr:
		if s == photoArr[currentlyGrabbedPhoto]:
			continue
		else:
			s.grabbed = false

func _on_sprite_3_picture_released():
	currentlyGrabbedPhoto = -1

func _on_sprite_4_picture_grabbed():
	currentlyGrabbedPhoto = 3
	for s in photoArr:
		if s == photoArr[currentlyGrabbedPhoto]:
			continue
		else:
			s.grabbed = false
	pass # Replace with function body.

func _on_sprite_4_picture_released():
	currentlyGrabbedPhoto = -1
