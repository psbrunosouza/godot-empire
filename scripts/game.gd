extends Node2D

class_name Game

signal attack_turn_started

const castle_scene: PackedScene = preload("res://scenes/castle.tscn")
const spot_scene: PackedScene = preload("res://scenes/spot.tscn")
const card_scene: PackedScene = preload("res://scenes/card.tscn")
const enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

@onready var spots_container = $SpotsContainer
@onready var ui = $UI
@onready var button = $UI/Container/ContainerVertical/Middle/VBoxContainer/ButtonEndTurn

var enemies_generated: bool

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
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	generate_enemies(2, 3)

func generate_enemies(enemies_quantity: int, enemies_per_turn: int):
	if  not enemies_generated:
		for i in range(enemies_quantity):
			var spots: Array[Spot] = []
			spots = GameManager.spots.filter(func(spot: Spot): return spot != null and not spot.is_ocuppied)
			if GameManager.turn % enemies_per_turn == 0 and spots.size() >= 1:
				var spot = spots[randi() % spots.size()]
				var enemy = create_enemy(
					GameManager.enemies_resources[
						GameManager.enemies_resources.keys().pick_random()
					]
				) as Enemy
				GameManager.enemies.append(enemy)
				spot.fill_spot(enemy)
				enemy.spot = spot
				enemies_generated = true

func generate_spots(coordinate: Vector2i):
	for x in range(coordinate.x -1, coordinate.x + 2):
		for y in range(coordinate.y -1, coordinate.y + 2):
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
	return enemy

func get_random_enemy() -> Enemy:
	return GameManager.enemies[randi() % GameManager.enemies.size()]

func perform_characters_attack():
	if GameManager.cards.size() >= 1:
		for card in GameManager.cards:
			if card is CardOnBoard and card.resource is CharacterResource and GameManager.enemies.size() >= 1:
				await card.attack(get_random_enemy())

func perform_enemy_attack():
	if GameManager.enemies.size() >= 1:
		for enemy in GameManager.enemies:
			if GameManager.cards.size() >= 1:
				var card = GameManager.cards[randi() % GameManager.cards.size()]
				if enemy != null and card != null:
					enemy.attack(card)
					await get_tree().create_timer(0.5).timeout

func _on_attack_turn_started():
	GameManager.turn += 1
	generate_cards()
	enemies_generated = false
	ui.turn_updated.emit(GameManager.turn)
	await perform_characters_attack()
	await perform_enemy_attack()
	button.disabled = false

