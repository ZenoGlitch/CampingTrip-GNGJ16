extends Sprite3D

@onready var animation_player = $AnimationPlayer
@onready var pigeon_non_photo = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("new_animation")
	animation_player.play("move")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "move":
		if self.is_flipped_h():
			self.set_flip_h(false)
			animation_player.play_backwards("move")
		else:
			self.set_flip_h(true)
			animation_player.play()
		
	pass # Replace with function body.
