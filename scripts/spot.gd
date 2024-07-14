extends Area2D

class_name Spot

var card_on_board_scene: PackedScene = preload("res://scenes/card_on_board.tscn") 
var coordinate: Vector2i = Vector2.ZERO
var is_ocuppied: bool = false

func _on_mouse_entered():
	GameManager.is_over_the_spot = true
	GameManager.selected_spot = self

func _on_mouse_exited():
	GameManager.is_over_the_spot = false
	GameManager.selected_spot = null
