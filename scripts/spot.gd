extends Area2D

class_name Spot

@onready var sprite: Sprite2D = $Sprite2D

var card_on_board_scene: PackedScene = preload("res://scenes/card_on_board.tscn") 
var coordinate: Vector2i = Vector2.ZERO
var is_ocuppied: bool = false

func fill_spot(unit): 
	is_ocuppied = true
	sprite.hide()
	add_child(unit)

func _on_mouse_entered():
	GameManager.is_over_the_spot = true
	GameManager.selected_spot = self

func _on_mouse_exited():
	GameManager.is_over_the_spot = false
	GameManager.selected_spot = null
