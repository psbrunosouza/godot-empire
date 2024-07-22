extends CharacterBody2D

class_name CardCastle

var damage_taken_scene: PackedScene = load("res://scenes/damage_taken.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer 

func _ready():
	animation_player.connect("animation_finished", _on_animation_finished)

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
	GameManager.life -= damage
	get_node("/root/Game/UI").life_updated.emit()
	animation_player.play("hitted")
	create_damage_taken_label(damage)

func _on_animation_finished(anim_name: String):
	if anim_name == "hitted":
		animation_player.play("RESET")
