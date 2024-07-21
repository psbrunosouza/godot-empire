extends CharacterBody2D

class_name Enemy

var projectile_scene: PackedScene =  load("res://scenes/projectile.tscn")
var projectile: Projectile
var max_life: int
var life: int
var power: int
var _last_position: Vector2
var resource: EnemyResource: set = set_resource
var target

func take_damage(damage: int):
	if life <= 0:
		var card_index = GameManager.enemies.find(self)
		if card_index != -1:
			GameManager.enemies.remove_at(card_index)
			queue_free()
	else:
		life -= damage

func attack(card):
	target = card
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
		distance/ 280).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	attack_tween.connect("finished", _on_attack_finished)

func set_resource(_resource: EnemyResource):
	resource = _resource
	$Sprite.texture = resource.texture
	max_life = resource.life
	life = resource.life
	power = resource.power
	resource.projectile_resource = _resource.projectile_resource

func _on_attack_finished():
	target.take_damage(power)
	projectile.queue_free()
