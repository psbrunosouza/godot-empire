extends CharacterBody2D

class_name CardOnBoard

var card_resource = null: set = _set_card_resource

func _set_card_resource(_card_resource):
	card_resource = _card_resource
	$Sprite2D.texture = _card_resource.card_texture
	
