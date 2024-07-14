extends MarginContainer

class_name Card

const MOUSE_LEFT_BUTTON = 1

var card_in_hand_scene: PackedScene = preload("res://scenes/card_in_hand.tscn")
var card_on_board_scene: PackedScene = preload("res://scenes/card_on_board.tscn")
var card_highlighted: bool = false
var card_in_hand: CardInHand = null
var card_resource: CardResource = null : set = _set_card_resource

@onready var card_sprite: Sprite2D = $Sprite2D 

func _unhandled_input(event):
	if (event is InputEventMouseButton) and event.button_index == MOUSE_LEFT_BUTTON:
		if event.is_pressed():
			# segurar uma carta na mão
			if card_highlighted:
				card_in_hand = card_in_hand_scene.instantiate() 
				card_in_hand.card_resource = card_resource
				get_tree().root.get_node("Game/SelectedCard").add_child(card_in_hand)
				card_sprite.hide()
		elif GameManager.is_over_the_spot:
			if not GameManager.selected_spot.is_ocuppied:
				# inserir card no slot
				var card_on_board = card_on_board_scene.instantiate() as CardOnBoard
				card_on_board.card_resource = card_resource
				GameManager.selected_spot.add_child(card_on_board)
				if card_in_hand:
					queue_free()
					card_in_hand.queue_free()
					
				# gerar spots em torno da carta inserida
				var game = get_tree().root.get_node("/root/Game") as Game
				game.generate_spots_around_signal.emit(GameManager.selected_spot.coordinate)
			else:
				# dropar a carta se não estiver sobre um slot
				card_sprite.show()
				card_in_hand.queue_free()
		else:
			if card_in_hand:
				card_sprite.show()
				card_in_hand.queue_free()
	
func _set_card_resource(p_card_resource: CardResource):
	var sprite: Sprite2D = $Sprite2D
	card_resource = p_card_resource
	sprite.texture = p_card_resource.card_texture

func _on_mouse_entered():
	card_highlighted = true

func _on_mouse_exited():
	card_highlighted = false
