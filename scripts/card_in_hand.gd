extends CharacterBody2D

class_name CardInHand

var card_resource = null : set = _set_card_resource

func _process(_delta):
	global_position = get_global_mouse_position()

func _set_card_resource(_card_resource):
	card_resource = _card_resource
	$Sprite2D.texture = card_resource.card_texture

