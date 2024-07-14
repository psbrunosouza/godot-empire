extends CharacterBody2D

class_name CardOnBoard

var card_resource: CardResource = null: set = _set_card_resource

func _set_card_resource(_card_resource: CardResource):
	card_resource = _card_resource
	var sprite = $Sprite2D as Sprite2D
	sprite.texture = _card_resource.card_texture
	
