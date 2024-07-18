extends Node

signal add_enemy

var spot_scene: PackedScene = preload("res://scenes/spot.tscn")
var card_resources: Dictionary = {}
var spots: Array[Spot] = []
var is_over_the_spot: bool = false
var selected_spot: Spot = null 
var enemies: Array[Enemy] = []

func _init():
	initialize_card_resources()

func check_spot_ocuppied(coordinate: Vector2i) -> bool:
	var spot_is_ocuppied: bool = false

	for spot in GameManager.spots:
		if spot.coordinate == coordinate:
			spot_is_ocuppied = true
	return spot_is_ocuppied

func create_spot(coordinate: Vector2i) -> Spot: 
	var spot = spot_scene.instantiate() as Spot
	spot.coordinate = coordinate
	spot.global_position = Vector2(
		coordinate.x * 32,
		coordinate.y * 32
	)
	GameManager.spots.append(spot)
	return spot

func initialize_card_resources():
	card_resources = {
		"forest": load("res://resources/place_resources/forest.tres"),
		#"archer": load("res://resources/character_resources/archer.tres"),
		#"rogue": load("res://resources/character_resources/rogue.tres"),
		#"sorcerer": load("res://resources/character_resources/sorcerer.tres"),
		#"warrior": load("res://resources/character_resources/warrior.tres"),
	}


