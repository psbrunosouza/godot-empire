extends HBoxContainer

const card_scene: PackedScene = preload("res://scenes/card.tscn")

func _ready():
	initialize_cards()

func initialize_cards(): 
	for value in range(1, 4):
		var random_resource = GameManager.card_resources.keys().pick_random()
		var card = card_scene.instantiate() as Card
		card.card_resource = GameManager.card_resources[random_resource]
		add_child(card)
	

