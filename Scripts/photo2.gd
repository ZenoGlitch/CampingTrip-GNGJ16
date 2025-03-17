class_name Photo
extends Node2D

@onready var sprite = $PhotoSprite
@onready var star1 = $PhotoSprite/StarSprite1
@onready var star2 = $PhotoSprite/StarSprite2
@onready var star3 = $PhotoSprite/StarSprite3
@onready var deletePhotoButton = $PhotoSprite/DeletePhotoButton
@onready var starArr: Array[Sprite2D] = [$PhotoSprite/StarSprite1, $PhotoSprite/StarSprite2, $PhotoSprite/StarSprite3]

var placeHolderTexture : Texture2D
var size : Vector2i = Vector2i(384, 216)
var originalPosition : Vector2
var grabbed : bool = false
var mouseOffset : Vector2 = Vector2(0, 0)
var allowedToMove : bool = true
var starsAmount : int = 0

signal pictureGrabbed
signal pictureReleased


var ID : int = -1

var isPigeonPic : bool = false
var isCrowPic : bool = false
var isBeePic : bool = false
var isSkunkPic : bool = false

signal scrapbookPhotoDeleted

# Called when the node enters the scene tree for the first time.
func _ready():
	self.placeHolderTexture = load("res://Assets/transparentPlaceholder.png")
	self.deletePhotoButton.visible = false
	self.star1.visible = false
	self.star2.visible = false
	self.star3.visible = false
	self.originalPosition = self.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.grabbed and self.allowedToMove:
		self.followMouse()
	if self.visible:
		deletePhotoButton.visible = true
		assert(self.starsAmount >= 0 and self.starsAmount <=3, "starsAmount is out of bounds")
		if self.starsAmount > 0 and self.starsAmount <= 3:
			for i in range(self.starsAmount):
				self.starArr[i].visible = true
				starArr.size()
	else:
		deletePhotoButton.visible = false
		for i in starArr.size():
			starArr[i].visible = false
			

func _input(event):
	if Input.is_action_just_pressed("TakePhoto") and self.visible and sprite.texture.resource_path != "res://Assets/transparentPlaceholder.png":
		if self.sprite.get_rect().has_point(to_local(event.position)):
			self.mouseOffset = position - get_global_mouse_position()
			self.grabbed = true
			self.pictureGrabbed.emit()
	if Input.is_action_just_released("TakePhoto"):
		self.grabbed = false
		self.pictureReleased.emit()

func followMouse():
	self.position = get_global_mouse_position() + self.mouseOffset
	
func setPhotoTexture(tex : ImageTexture):
	self.sprite.texture = tex
	
func setStarsAmount(amount : int):
	self.starsAmount = amount
	
func disableAllStars():
	self.star1.visible = false
	self.star2.visible = false
	self.star3.visible = false
	self.starsAmount = 0

func fullyResetPhoto():
	self.sprite.texture = placeHolderTexture
	self.disableAllStars()
	self.isPigeonPic = false
	self.isCrowPic = false
	self.isBeePic = false
	self.isSkunkPic = false
	self.visible = false
	self.position = originalPosition
	self.allowedToMove = true
	self.grabbed = false

func _on_area_2d_mouse_entered():
	#if self.sprite.texture != placeHolderTexture:
		#self.deletePhotoButton.visible = true
	pass
	
func _on_area_2d_mouse_exited():
	#self.deletePhotoButton.visible = false
	pass
func _on_delete_photo_button_pressed():
	fullyResetPhoto()
	self.scrapbookPhotoDeleted.emit(ID)
