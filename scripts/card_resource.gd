extends Resource

class_name CardResource

@export var life: int
@export var power: int
@export var defense: int
@export var card_texture: Texture

func _init(p_life = 0, p_power = 0, p_defense = 0, p_card_texture = null):
	card_texture = p_card_texture
	life = p_life
	power = p_power
	defense = p_defense
