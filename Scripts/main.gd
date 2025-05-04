extends Node3D

@onready var player = $Player

@onready var pigeon = $Pigeon
@onready var crow = $Crow
@onready var bee = $Bee
@onready var skunk = $Skunk

# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().set_title("I'm in the forest with my dad and the frogs are watching")
	
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
	pass
	

func OnPigeonSus(isPigeonSus):
	Global.pigeonsAreSus = isPigeonSus

func OnCrowsSus(isCrowSus):
	Global.crowsAreSus = isCrowSus

func OnBeesSus(isBeeSus):
	Global.beesAreSus = isBeeSus

func OnSkunkSus(isSkunkSus):
	Global.skunksAreSus = isSkunkSus

func OnSusPigeonPhoto():
	pigeon.pigeon1.set_frame(2)
	pigeon.pigeon1.set_flip_h(true)
	pigeon.pigeon2.set_frame(2)
	pigeon.sussyPhotoCaptured = true
	await player.sussyPhotoTimer.timeout
	pigeon.pigeon1.set_frame(0)
	pigeon.pigeon1.set_flip_h(true)
	pigeon.pigeon2.set_frame(0)
	pigeon.sussyPhotoCaptured = false
	
func OnSusCrowPhoto():
	crow.crow1.set_frame(2)
	crow.crow2.set_frame(2)
	crow.sussyPhotoCaptured = true
	await player.sussyPhotoTimer.timeout
	crow.crow1.set_frame(0)
	crow.crow2.set_frame(0)
	crow.sussyPhotoCaptured = false
	
func OnSusBeePhoto():
	bee.bee1.set_frame(2)
	bee.bee1.set_flip_h(true)
	bee.bee2.set_frame(2)
	bee.sussyPhotoCaptured = true
	await player.sussyPhotoTimer.timeout
	bee.bee1.set_frame(0)
	bee.bee2.set_frame(0)
	bee.sussyPhotoCaptured = false

func OnSusSkunkPhoto():
	skunk.skunk.set_frame(2)
	skunk.sussyPhotoCaptured = true
	await player.sussyPhotoTimer.timeout
	skunk.skunk.set_frame(0)
	skunk.sussyPhotoCaptured = false
