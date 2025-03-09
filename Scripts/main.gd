extends Node3D

@onready var player = $Player
@onready var animal = $Animal

@onready var pigeon = $Pigeon
@onready var crow = $Crow
@onready var bee = $Bee
@onready var skunk = $Skunk

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello GN!")
	
	pigeon.connect("pigeonsAreSus", OnPigeonSus)
	crow.connect("crowsAreSus", OnCrowsSus)
	bee.connect("beesAreSus", OnBeesSus)
	skunk.connect("skunksAreSus", OnSkunkSus)
	
	player.connect("susPigeonPhotoTaken", OnSusPigeonPhoto)
	player.connect("susCrowPhotoTaken", OnSusCrowPhoto)
	player.connect("susBeePhotoTaken", OnSusBeePhoto)
	player.connect("susSkunkPhotoTaken", OnSusSkunkPhoto)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	toggleAnimalAnimation()
	pass
	
func toggleAnimalAnimation():
	if player.facingDir == player.direction.NORTH:
		animal.animated_sprite_3d.play()
	else:
		animal.animated_sprite_3d.stop()

func OnPigeonSus(isPigeonSus):
	player.pigeonsAreSus = isPigeonSus

func OnCrowsSus(isCrowSus):
	player.crowsAreSus = isCrowSus

func OnBeesSus(isBeeSus):
	player.beesAreSus = isBeeSus

func OnSkunkSus(isSkunkSus):
	player.skunksAreSus = isSkunkSus

func OnSusPigeonPhoto():
	pigeon.pigeon1.set_frame(2)
	pigeon.pigeon1.set_flip_h(true)
	pigeon.pigeon2.set_frame(2)
	pigeon.sussyPhotoCaptured = true
	await player.pigeonPhotoTimer.timeout
	pigeon.pigeon1.set_frame(0)
	pigeon.pigeon1.set_flip_h(true)
	pigeon.pigeon2.set_frame(0)
	pigeon.sussyPhotoCaptured = false
	
func OnSusCrowPhoto():
	crow.crow1.set_frame(2)
	crow.crow2.set_frame(2)
	crow.sussyPhotoCaptured = true
	await player.crowPhotoTimer.timeout
	crow.crow1.set_frame(0)
	crow.crow2.set_frame(0)
	crow.sussyPhotoCaptured = false
	
func OnSusBeePhoto():
	bee.bee1.set_frame(2)
	bee.bee1.set_flip_h(true)
	bee.bee2.set_frame(2)
	bee.sussyPhotoCaptured = true
	await player.beePhotoTimer.timeout
	bee.bee1.set_frame(0)
	bee.bee2.set_frame(0)
	bee.sussyPhotoCaptured = false

func OnSusSkunkPhoto():
	skunk.skunk.set_frame(2)
	skunk.sussyPhotoCaptured = true
	await player.skunkPhotoTimer.timeout
	skunk.skunk.set_frame(0)
	skunk.sussyPhotoCaptured = false
