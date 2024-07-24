extends Node

signal add_enemy

var spot_scene: PackedScene = preload("res://entities/spots/spot.tscn")
var is_over_the_spot: bool = false
var selected_spot: Spot = null 
var card_resources: Dictionary = {}
var enemies_resources: Dictionary = {}
var spots: Array[Spot] = []
var enemies: Array[Enemy] = []
var cards: Array = []
var places: Array[CardOnBoard] = []
var card_hand: Array[Card] = []
var turn: int = 1
var max_life: int = 10
var life: int = 10

enum EFFECT {
	SPAWN_GOBLIN,
	BREAK_RANDOM_DEFENSE,
	SPAWN_HOBGOBLIN,
	RANDOM_ALLY_TAKE_DAMAGE,
	HEAL_CASTLE,
	HEAL_RANDOM_ALLY,
	SHIELD_TO_RANDOM_ALLY,
	MORE_DAMAGE
}

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
		"forest": load("res://resources/places/forest.tres"),
		"archer": load("res://resources/characters/archer.tres"),
		"rogue": load("res://resources/characters/rogue.tres"),
		"sorcerer": load("res://resources/characters/sorcerer.tres"),
		"warrior": load("res://resources/characters/warrior.tres"),
	}
	
func intialize_enemies():
	enemies_resources = {
		"goblin":  load("res://resources/enemies/goblin.tres") 
	}
	

