class_name GameController
extends Node

@export var enemycounter: int
@export var waveSpawner: EnemySpawner
@export var player: Player

var gameEndScreen: Control

func _ready() -> void:
	gameEndScreen = player.find_child("GameOverMenu")

func _process(delta: float) -> void:
	enemycounter = get_tree().get_node_count_in_group("enemy")
	
	if waveSpawner.wave_count <= waveSpawner.current_wave and enemycounter <= 0:
		LevelComplete()
		

func LevelComplete():
	gameEndScreen.victory()
