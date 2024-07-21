extends CanvasLayer

signal life_updated(life: int)
signal turn_updated(turn: int)
signal cards_updated(cards: Array[Card])

@onready var enemies_container = $Container/ContainerVertical/Enemies
@onready var cards_container = $Container/ContainerVertical/Cards
@onready var button = $Container/ContainerVertical/Middle/VBoxContainer/ButtonEndTurn

func _ready():
	GameManager.add_enemy.connect(_on_add_enemy)

func _on_add_enemy(enemy: Enemy):
	enemies_container.add_child(enemy)

func _on_button_end_turn_button_down():
	button.disabled = true
	get_node("/root/Game").attack_turn_started.emit()

func _on_life_updated():
	$Container/ContainerVertical/HUD/Life.text = "Life " + str(GameManager.life)

func _on_turn_updated(turn: int):
	$Container/ContainerVertical/HUD/Turn.text = "Turn " + str(turn)

func _on_cards_updated(cards):
	if cards_container.get_child_count() >= 1:
		for card in cards_container.get_children():
			card.queue_free()
		
	for card in cards:
		cards_container.add_child(card)
