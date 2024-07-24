extends Resource

class_name CharacterResource

@export_category("Attributes")
@export var id: String
@export var life: int = 5
@export var power: int = 5
@export var has_shield: bool = false
@export var has_double_hit: bool = false
@export_category("Texture")
@export var texture: Texture
@export_category("Misc")
@export var projectile_resource: ProjectileResource

