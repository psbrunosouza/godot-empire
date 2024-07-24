extends MarginContainer

class_name Card

var card_in_hand_scene: PackedScene = preload("res://entities/characters/card_in_hand.tscn")
var card_on_board_scene: PackedScene = preload("res://entities/characters/card_on_board.tscn")
var card_in_hand: CardInHand = null
var card_highlighted: bool = false
var is_dragging: bool = false
var card_resource: Resource : set = set_card_resource
var spot: Spot

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
				
				if not GameManager.selected_spot.is_ocuppied:
					GameManager.selected_spot.sprite.hide()
					GameManager.selected_spot.add_child(card_on_board)
				
					if card_on_board.resource is CharacterResource:
						GameManager.cards.append(card_on_board)
					elif card_on_board.resource is PlaceResource:
						GameManager.places.append(card_on_board)
					
					card_on_board.spot = GameManager.selected_spot
					card_on_board.spot.is_ocuppied = true
					
					is_dragging = false
					card_in_hand.queue_free()
					queue_free()
				else:
					$TextureRect.show()
					if card_in_hand:
						card_in_hand.queue_free()
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

