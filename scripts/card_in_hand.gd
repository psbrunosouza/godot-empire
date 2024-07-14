extends MarginContainer

class_name CardInHand

var card_resource: CardResource = null : set = _set_card_resource

func _process(_delta):
	global_position = get_global_mouse_position()

func _set_card_resource(_card_resource: CardResource):
	var sprite = $Sprite2D as Sprite2D
	card_resource = _card_resource
	sprite.texture = card_resource.card_texture
	
	
