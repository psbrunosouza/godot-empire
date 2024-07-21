extends Resource

class_name CardPlaceResource

enum PLACE {
	FOREST,
	OCEAN,
	MOUNTAINS,
	PLAINS
}

enum NEGATIVE_ACTION {
	SPAWN_WOLVE,
	DEFENSE_BREAK,
}

enum POSITIVE_ACTION {
	HEAL_CASTLE
}

@export_category("Attributes")
@export_category("ID")
@export var id: PLACE = PLACE.FOREST
@export_group("Base Attributes")
@export var life: int = 0
@export var damage: int = 0
@export var shield: bool = false
@export_group("Effects")
@export var effect_multiplier: int = 1
@export_category("Abilities")
@export var positive_effect: POSITIVE_ACTION
@export var negative_effect: NEGATIVE_ACTION
@export_category("Texture")
@export var texture: Texture = null

func call_effects():
	match id:
		PLACE.FOREST:
			if randi_range(0, 1) == 0:
				match negative_effect:
					NEGATIVE_ACTION.SPAWN_WOLVE:
						#for values in range(randi_range(1, effect_multiplier)):
							#var enemy = load("res://scenes/enemy.tscn").instantiate()
							#enemy.resource = load("res://resources/enemy_resources/wolve.tres")
							#GameManager.enemies.append(enemy)
							#GameManager.add_enemy.emit(enemy)
							pass
			else:
				match positive_effect:
					POSITIVE_ACTION.HEAL_CASTLE:
						#print("vc recebeu um efeito positivo")
						pass
		PLACE.OCEAN:
			print("OCEAN")
		PLACE.MOUNTAINS:
			print("MOUNTAINS")
		PLACE.PLAINS:
			print("PLAINS") 
