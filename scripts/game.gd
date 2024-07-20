extends Node2D

class_name Game

signal attack_turn_started

const castle_scene: PackedScene = preload("res://scenes/castle.tscn")
const spot_scene: PackedScene = preload("res://scenes/spot.tscn")
const card_scene: PackedScene = preload("res://scenes/card.tscn")
const enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

@onready var spots_container = $SpotsContainer
@onready var ui = $UI

var enemies_generated: bool = false

func _ready():
	# create cards hand
	generate_cards()
	
	# create first spot
	var spot = create_spot(Vector2i.ZERO)
	GameManager.spots.append(spot)
	spots_container.add_child(spot)
	
	# create castle
	var castle: CardCastle = castle_scene.instantiate() as CardCastle
	spot.fill_spot(castle)
	GameManager.cards.append(castle)
	
	# initial life
	GameManager.life = 10
	ui.life_updated.emit()
	
	# create spots around
	generate_spots(spot.coordinate)

func _process(_delta):
	if GameManager.life == 0:
		print("end game")
	generate_enemies(2, 4)

func generate_enemies(quantity_of_enemies: int, quantity_of_turns: int): 
	if quantity_of_enemies >= 1 and not enemies_generated:
		if GameManager.turn == 1 or GameManager.turn % quantity_of_turns == 0:
			var spot = GameManager.spots[randi() % GameManager.spots.size()]
			var enemy = create_enemy(
				GameManager.enemies_resources[
					GameManager.enemies_resources.keys().pick_random()
				]
			)
			if spot.is_ocuppied:
				enemy.queue_free()
				generate_enemies(quantity_of_enemies, quantity_of_turns)
			else:
				spot.fill_spot(enemy)
				generate_enemies(quantity_of_enemies-1, quantity_of_turns)
	else:
		enemies_generated = true

func generate_spots(coordinate: Vector2i):
	for x in range(coordinate.x -3, coordinate.x + 4):
		for y in range(coordinate.y -3, coordinate.y + 4):
			var spot_coordinate = Vector2i(x, y)
			if not GameManager.spot_ocuppied(spot_coordinate):
				var spot = create_spot(spot_coordinate)
				GameManager.spots.append(spot)
				spots_container.add_child(spot)

func generate_cards(): 
	if GameManager.card_hand.size() >= 1:
		GameManager.card_hand = []
	
	for value in range(1, 4):
		var random_resource = GameManager.card_resources.keys().pick_random()
		var card = create_card(random_resource)
		GameManager.card_hand.append(card)
		
	ui.cards_updated.emit(GameManager.card_hand)

func create_card(resource) -> Card: 
	var card = card_scene.instantiate() as Card
	card.card_resource = GameManager.card_resources[resource]
	return card

func create_spot(coordinate: Vector2i) -> Spot: 
	var spot: Spot = spot_scene.instantiate()
	spot.coordinate = coordinate
	spot.global_position = Vector2(coordinate.x * 32,coordinate.y * 32)
	return spot

func create_enemy(resource) -> Enemy:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.resource = resource
	GameManager.enemies.append(enemy)
	return enemy

func perform_characters_attack():
	if GameManager.cards.size():
		for card in GameManager.cards:
			if card is CardOnBoard:
				if  card.resource is CharacterResource:
					var enemy = GameManager.enemies[randi() % GameManager.enemies.size()]
					card.attack(enemy)
					await get_tree().create_timer(1).timeout

func perform_enemy_attack():
	if GameManager.enemies.size():
		for enemy in GameManager.enemies:
			if GameManager.cards.size():
				var card = GameManager.cards[randi() % GameManager.cards.size()]
				enemy.attack(card)
				await get_tree().create_timer(1).timeout

func _on_attack_turn_started():
	GameManager.turn += 1
	generate_cards()
	enemies_generated = false
	ui.turn_updated.emit(GameManager.turn)
	await perform_characters_attack()
	perform_enemy_attack()

