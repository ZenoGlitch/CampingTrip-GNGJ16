extends Node

enum GameState {MAIN_MENU, RUNNING, ENDED} 
var gameState : GameState = GameState.MAIN_MENU

var crowsAreSus : bool = false
var pigeonsAreSus : bool = false
var beesAreSus : bool = false
var skunksAreSus : bool = false : 
	set(value): 
		skunksAreSus = value 
	get(): 
		return skunksAreSus

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
