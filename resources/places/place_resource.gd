extends Resource

class_name PlaceResource

enum PLACE {
	FOREST,
	OCEAN,
	MOUNTAINS,
	PLAINS
}

@export_category("Attributes")
@export_category("ID")
@export var id: PLACE 
@export_group("Base Attributes")
@export var time_to_activate: int
@export_category("Texture")
@export var texture: Texture

func get_effect() -> GameManager.EFFECT:
	var effect: GameManager.EFFECT
	match id:
		PLACE.FOREST:
			var possible_effects = [GameManager.EFFECT.SPAWN_GOBLIN, GameManager.EFFECT.HEAL_CASTLE]
			effect = possible_effects[randi() % possible_effects.size()]
		PLACE.OCEAN:
			var possible_effects = [GameManager.EFFECT.RANDOM_ALLY_TAKE_DAMAGE, GameManager.EFFECT.HEAL_RANDOM_ALLY]
			effect = possible_effects[randi() % possible_effects.size()]
		PLACE.MOUNTAINS:
			var possible_effects = [GameManager.EFFECT.SPAWN_HOBGOBLIN, GameManager.EFFECT.SHIELD_TO_RANDOM_ALLY]
			effect = possible_effects[randi() % possible_effects.size()]
		PLACE.PLAINS:
			var possible_effects = [GameManager.EFFECT.MORE_DAMAGE, GameManager.EFFECT.BREAK_RANDOM_DEFENSE]
			effect = possible_effects[randi() % possible_effects.size()]
	return effect
