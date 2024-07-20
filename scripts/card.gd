extends MarginContainer

class_name Card

var card_in_hand_scene: PackedScene = preload("res://scenes/card_in_hand.tscn")
var card_on_board_scene: PackedScene = preload("res://scenes/card_on_board.tscn")
var card_in_hand: CardInHand = null
var card_highlighted: bool = false
var is_dragging: bool = false
var card_resource: Resource : set = set_card_resource

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# drag card
		if event.is_pressed():
			if card_highlighted:
				card_in_hand = card_in_hand_scene.instantiate() as CardInHand
				card_in_hand.card_resource = card_resource
				get_node("/root/Game/CardsContainer").add_child(card_in_hand)
				$TextureRect.hide()
				is_dragging = true
		
		# drop card
		if event.is_released():
			if is_dragging and GameManager.is_over_the_spot:
				# place card on board
				var card_on_board: CardOnBoard = card_on_board_scene.instantiate() as CardOnBoard
				card_on_board.resource = card_resource
				GameManager.selected_spot.sprite.hide()
				GameManager.selected_spot.add_child(card_on_board)
				
				if card_on_board.resource is CharacterResource:
					GameManager.cards.append(card_on_board)
				elif card_on_board.resource is CardPlaceResource:
					card_on_board.resource.call_effects()
				
				#var game = get_tree().root.get_node("/root/Game") as Game
				#game.generate_spots_around_signal.emit(GameManager.selected_spot.coordinate)
				
				is_dragging = false
				card_in_hand.queue_free()
				queue_free()
				
			elif is_dragging:
				is_dragging = false
				card_in_hand.queue_free()
				$TextureRect.show()

func set_card_resource(_card_resource):
	card_resource = _card_resource
	$TextureRect.texture = card_resource.texture

func _on_mouse_entered():
	card_highlighted = true

func _on_mouse_exited():
	card_highlighted = false

