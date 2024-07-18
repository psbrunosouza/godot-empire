extends HBoxContainer

func _ready():
	GameManager.add_enemy.connect(_on_add_enemy)

func _on_add_enemy(enemy: Enemy):
	add_child(enemy)
