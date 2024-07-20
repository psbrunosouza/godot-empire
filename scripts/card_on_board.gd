extends CharacterBody2D

class_name CardOnBoard

var projectile_scene: PackedScene =  load("res://scenes/projectile.tscn")
var projectile: Projectile = null
var resource: Resource: set = _set_card_resource
var _last_position: Vector2 = Vector2.ZERO
var life: int

func _set_card_resource(_card_resource):
	var sprite = $Sprite2D

	resource = _card_resource
	sprite.texture = resource.texture
	life = resource.life

func take_damage(damage: int):
	life -= damage

func attack(enemy: Enemy):
	projectile = projectile_scene.instantiate() as Projectile
	projectile.resource = resource.projectile_resource
	add_child(projectile)
	_last_position = projectile.global_position
	var distance = projectile.global_position.distance_to(enemy.global_position)
	var attack_tween = create_tween()
	attack_tween.tween_property(
		projectile, 
		"global_position", 
		enemy.global_position, 
		distance / 280).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	attack_tween.connect("finished", _on_attack_finished)
	
func _on_attack_finished():
	projectile.queue_free()
