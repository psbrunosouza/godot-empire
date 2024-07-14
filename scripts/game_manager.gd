extends Node

@export var card_resources: Dictionary = {}

const card_resource = preload("res://scripts/card_resource.gd")
const spot_scene: PackedScene = preload("res://scenes/spot.tscn")

var spots: Array[Spot] = []
var is_over_the_spot: bool = false
var selected_spot: Spot = null 
var life = 10
var defense = 0

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
		"forest": card_resource.new(
			0,
			0,
			5,
			preload("res://assets/forest.png")
		)
	}


