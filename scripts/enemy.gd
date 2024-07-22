extends CharacterBody2D

class_name Enemy

var projectile_scene: PackedScene =  load("res://scenes/projectile.tscn")
var damage_taken_scene: PackedScene = load("res://scenes/damage_taken.tscn")

var projectile: Projectile
var max_life: int
var life: int
var power: int
var _last_position: Vector2
var resource: EnemyResource: set = set_resource
var spot: Spot

@onready var life_bar: TextureProgressBar = $Life
@onready var animation_player: AnimationPlayer = $AnimationPlayer 

func _ready():
	animation_player.connect("animation_finished", _on_animation_finished)

func _process(_delta):
	if life <= 0:
		var card_index = GameManager.enemies.find(self)
		if card_index != -1:
			GameManager.enemies.remove_at(card_index)
			spot.is_ocuppied = false
			spot.sprite.show()
			queue_free()

func create_damage_taken_label(damage: int):
	var damage_taken = damage_taken_scene.instantiate()
	damage_taken.text = str(damage)
	damage_taken.position = Vector2(randi_range(-5, 5), 0)
	var target_vector = Vector2(damage_taken.position.x, -10)
	add_child(damage_taken)
	
	var tween = create_tween()
	tween.tween_property(damage_taken, "position", target_vector, 0.8)
	
	await tween.finished
	damage_taken.queue_free()

func take_damage(damage: int):
	life -= damage
	life_bar.value -= damage
	animation_player.play("hitted")
	create_damage_taken_label(damage)

func attack(card):
	projectile = projectile_scene.instantiate() as Projectile
	projectile.resource = resource.projectile_resource
	add_child(projectile)
	
	projectile.rotation_degrees = -45
	var target_angle = projectile.get_angle_to(card.global_position) * (180/3.14)
	projectile.rotation_degrees = target_angle
	
	_last_position = projectile.global_position
	var distance = projectile.global_position.distance_to(card.global_position)
	var attack_tween = create_tween()
	attack_tween.tween_property(
		projectile, 
		"global_position", 
		card.global_position, 
		distance/ 250).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await attack_tween.finished
	projectile.queue_free()
	card.take_damage(power)
	await get_tree().create_timer(0.5).timeout

func set_resource(_resource: EnemyResource):
	resource = _resource
	$Sprite.texture = resource.texture
	max_life = resource.life
	life = resource.life
	power = resource.power
	resource.projectile_resource = _resource.projectile_resource
	$Life.max_value = max_life
	$Life.value = life

func _on_animation_finished(anim_name: String):
	if anim_name == "hitted":
		animation_player.play("RESET")
