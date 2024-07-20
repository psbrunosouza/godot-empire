extends CanvasLayer

@onready var enemies_container = $Container/ContainerVertical/Enemies
@onready var cards_container = $Container/ContainerVertical/Cards


func _ready():
	GameManager.add_enemy.connect(_on_add_enemy)

func _on_add_enemy(enemy: Enemy):
	enemies_container.add_child(enemy)

func _on_game_update_card_hand(cards: Array[Card]):
	if cards_container.get_child_count() >= 1:
		for card in cards_container.get_children():
			card.queue_free()
		
	for card in cards:
		cards_container.add_child(card)


func _on_button_end_turn_button_down():
	get_node("/root/Game").attack_turn_started.emit()
