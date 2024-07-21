extends CharacterBody2D

class_name CardCastle

func take_damage(damage: int):
	if GameManager.life - damage < 0:
		GameManager.life = 0
	else:
		GameManager.life -= damage
	get_node("/root/Game/UI").life_updated.emit()
