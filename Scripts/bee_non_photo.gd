extends Sprite3D

@onready var animation_player = $BeeAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("Bee1_move")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
