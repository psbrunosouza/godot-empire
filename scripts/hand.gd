extends HBoxContainer

const card_scene: PackedScene = preload("res://scenes/card.tscn")

func _ready():
	initialize_cards()

func initialize_cards(): 
	for card_resource in GameManager.card_resources.keys():
		var card = card_scene.instantiate() as Card
		card.card_resource = GameManager.card_resources[card_resource]
		add_child(card)
