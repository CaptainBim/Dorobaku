extends Node

const PLAYER = preload("res://res/scene/player.tscn")

signal interact_pressed
var interact_handled : bool = true

func interact() -> void:
	interact_handled = false
	interact_pressed.emit()
