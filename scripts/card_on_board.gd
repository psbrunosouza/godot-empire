extends CharacterBody2D

class_name CardOnBoard

var projectile_scene: PackedScene =  load("res://scenes/projectile.tscn")
var projectile: Projectile 
var _last_position: Vector2
var max_life: int
var life: int
var power: int
var has_shield: bool
var resource: Resource: set = _set_card_resource
var spot: Spot
var target: Enemy

@onready var life_bar: TextureProgressBar = $Life
@onready var animation_player: AnimationPlayer = $AnimationPlayer 

func _ready():
	if resource is CardPlaceResource:
		life_bar.hide()
	animation_player.connect("animation_finished", _on_animation_finished)

func _process(_delta):
	if life <= 0:
		var card_index = GameManager.cards.find(self)
		if card_index != -1:
			GameManager.cards.remove_at(card_index)
			spot.is_ocuppied = false
			spot.sprite.show()
			queue_free()

func take_damage(damage: int):
	life -= damage
	life_bar.value -= damage
	animation_player.play("hitted")

func attack(enemy: Enemy):
	target = enemy
	projectile = projectile_scene.instantiate() as Projectile
	projectile.resource = resource.projectile_resource
	add_child(projectile)
	
	projectile.rotation_degrees = -45
	var target_angle = projectile.get_angle_to(target.global_position) * (180/3.14)
	projectile.rotation_degrees = target_angle
	
	_last_position = projectile.global_position
	var distance = projectile.global_position.distance_to(target.global_position)
	var attack_tween = create_tween()
	attack_tween.tween_property(
		projectile, 
		"global_position", 
		target.global_position, 
		distance / 250).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	attack_tween.connect("finished", _on_attack_finished)
	await get_tree().create_timer(0.5).timeout

func _set_card_resource(_card_resource):
	var sprite: Sprite2D = $Sprite2D
	
	resource = _card_resource
	sprite.texture = resource.texture
	max_life = resource.life
	life = resource.life
	if "power" in resource:
		power = resource.power
	if "has_shield" in resource:
		has_shield = resource.has_shield
	
	$Life.max_value = max_life
	$Life.value = life
	
func _on_attack_finished():
	target.take_damage(power)
	projectile.queue_free()

func _on_animation_finished(anim_name: String):
	if anim_name == "hitted":
		animation_player.play("RESET")
