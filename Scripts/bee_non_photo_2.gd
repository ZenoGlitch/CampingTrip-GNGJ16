extends Sprite3D

@onready var bee_animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	bee_animation_player.play("bee2_move")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
