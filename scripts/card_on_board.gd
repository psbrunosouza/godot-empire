extends CharacterBody2D

class_name CardOnBoard

var projectile_scene: PackedScene =  load("res://scenes/projectile.tscn")
var projectile: Projectile 
var _last_position: Vector2
var max_life: int
var life: int
var power: int
var resource: Resource: set = _set_card_resource
var target: Enemy

func take_damage(damage: int):
	if life <= 0:
		var card_index = GameManager.cards.find(self)
		if card_index != -1:
			GameManager.cards.remove_at(card_index)
			queue_free()
	else:
		life -= damage

func attack(enemy: Enemy):
	target = enemy
	projectile = projectile_scene.instantiate() as Projectile
	projectile.resource = resource.projectile_resource
	add_child(projectile)
	_last_position = projectile.global_position
	var distance = projectile.global_position.distance_to(target.global_position)
	var attack_tween = create_tween()
	attack_tween.tween_property(
		projectile, 
		"global_position", 
		target.global_position, 
		distance / 280).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	attack_tween.connect("finished", _on_attack_finished)
	await get_tree().create_timer(0.5).timeout

func _set_card_resource(_card_resource):
	var sprite = $Sprite2D
	resource = _card_resource
	sprite.texture = resource.texture
	max_life = resource.life
	life = resource.life
	if "power" in resource:
		power = resource.power

func _on_attack_finished():
	target.take_damage(power)
	projectile.queue_free()
