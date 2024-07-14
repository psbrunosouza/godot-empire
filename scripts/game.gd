extends Node2D

class_name Game

signal generate_spots_around_signal

var castle_scene: PackedScene = preload("res://scenes/card_castle.tscn")
var spot_scene: PackedScene = preload("res://scenes/spot.tscn")
@onready var spots_container: Node2D = $SpotsContainer

func _ready():
	# gerar o primeiro spot que é o centro da gameplay
	var spot = GameManager.create_spot(Vector2i.ZERO)
	spot.is_ocuppied = true
	spots_container.add_child(spot)
	
	# gerar o castelo dentro do primeiro spot
	var castle = castle_scene.instantiate() as CardCastle
	spot.add_child(castle)
	
	# gerar os spots em torno do spot principal
	generate_spots_around_signal.emit(spot.coordinate)

func _on_generate_spots_around_signal(coordinate: Vector2i):
	for x in range(coordinate.x -1, coordinate.x + 2):
		for y in range(coordinate.y -1, coordinate.y + 2):
			var spot_around_coordinate = Vector2i(x, y)
			
			if not GameManager.check_spot_ocuppied(spot_around_coordinate):
				var spot_around = GameManager.create_spot(spot_around_coordinate)
				spots_container.add_child(spot_around)
