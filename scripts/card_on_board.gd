extends CharacterBody2D

class_name CardOnBoard

var projectile_scene: PackedScene =  load("res://scenes/projectile.tscn")
var projectile: Projectile = null
var card_resource = null: set = _set_card_resource
var _last_position: Vector2 = Vector2.ZERO

func _set_card_resource(_card_resource):
	card_resource = _card_resource
	$Sprite2D.texture = _card_resource.card_texture
	
func attack():
	projectile = projectile_scene.instantiate()
	projectile.resource = card_resource.projectile_resource
	add_child(projectile)
	_last_position = projectile.global_position
	var attack_tween = create_tween()
	attack_tween.tween_property(
		projectile, 
		"global_position", 
		Vector2(20, 20), 
		1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	attack_tween.connect("finished", _on_attack_finished)
	
func _on_attack_finished():
	projectile.queue_free()
