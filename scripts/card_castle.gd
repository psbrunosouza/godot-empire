extends CharacterBody2D

class_name CardCastle

@onready var animation_player: AnimationPlayer = $AnimationPlayer 

func _ready():
	animation_player.connect("animation_finished", _on_animation_finished)

func take_damage(damage: int):
	GameManager.life -= damage
	get_node("/root/Game/UI").life_updated.emit()
	animation_player.play("hitted")

func _on_animation_finished(anim_name: String):
	if anim_name == "hitted":
		animation_player.play("RESET")
