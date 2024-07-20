extends CharacterBody2D

class_name CardCastle

func take_damage(damage: int):
	GameManager.life -= damage
