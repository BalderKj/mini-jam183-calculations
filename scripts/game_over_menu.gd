extends Control

@onready var loss_label: Label = $CenterContainer/VBoxContainer/LossLabel
@onready var victory_label: Label = $CenterContainer/VBoxContainer/VictoryLabel

func game_over() -> void:
		get_tree().paused = true
		visible = true
		victory_label.visible = false
		loss_label.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func victory() -> void:
	get_tree().paused = true
	visible = true
	loss_label.visible = false
	victory_label.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
