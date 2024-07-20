extends Node

signal add_enemy

var spot_scene: PackedScene = preload("res://scenes/spot.tscn")
var is_over_the_spot: bool = false
var selected_spot: Spot = null 
var card_resources: Dictionary = {}
var enemies_resources: Dictionary = {}
var spots: Array[Spot] = []
var enemies: Array[Enemy] = []
var cards: Array[CardOnBoard] = []
var card_hand: Array[Card] = []
var turn: int = 1
var life: int = 10

func _init():
	initialize_card_resources()
	intialize_enemies()

func spot_ocuppied(coordinate: Vector2i) -> bool:
	var spot_is_ocuppied: bool = false
	for spot in GameManager.spots:
		if spot.coordinate == coordinate:
			spot_is_ocuppied = true
	return spot_is_ocuppied

func initialize_card_resources():
	card_resources = {
		"forest": load("res://resources/place_resources/forest.tres"),
		"archer": load("res://resources/character_resources/archer.tres"),
		"rogue": load("res://resources/character_resources/rogue.tres"),
		"sorcerer": load("res://resources/character_resources/sorcerer.tres"),
		"warrior": load("res://resources/character_resources/warrior.tres"),
	}
	
func intialize_enemies():
	enemies_resources = {
		"wolf":  load("res://resources/enemy_resources/wolve.tres") 
	}
	

