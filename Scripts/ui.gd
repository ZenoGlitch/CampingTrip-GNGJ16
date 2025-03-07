extends Node2D

@onready var pictureCounterLabel = $CanvasLayer/Label
@onready var photoArr : Array[Sprite2D] = [$CanvasLayer/Sprite1, $CanvasLayer/Sprite2, $CanvasLayer/Sprite3, $CanvasLayer/Sprite4, $CanvasLayer/Sprite5, $CanvasLayer/Sprite6, $CanvasLayer/Sprite7, $CanvasLayer/Sprite8]
@onready var scrapbook = $CanvasLayer/Scrapbook
@onready var scrapbook2 = $CanvasLayer/Scrapbook2
@onready var scrapbook3 = $CanvasLayer/Scrapbook3
@onready var scrapbook4 = $CanvasLayer/Scrapbook4

@onready var scrapbookCollisionShape2d = $CanvasLayer/Scrapbook/Area2D/CollisionShape2D
@onready var sprite1 = $CanvasLayer/Sprite1


var pictureCounter : int = 0

var currentPage : int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pictureCounterLabel.text = str(pictureCounter)
	scrapbook2.visible = false
	scrapbook3.visible = false
	scrapbook4.visible = false
	
	
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#var collRect : Rect2 = scrapbookCollisionShape2d.shape.get_rect()
	#if sprite1.get_rect().intersects(scrapbookCollisionShape2d.shape.get_rect()):
		#print("YOUR MOM")
	#if scrapbookCollisionShape2d.shape.get_rect().intersects(sprite1.get_rect()):
		#print("YOURDADDDDD")
	pass
	
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
