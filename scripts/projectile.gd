extends CharacterBody2D

class_name Projectile

var resource: ProjectileResource = null: set = _set_projectile_resource

func _set_projectile_resource(_resource: ProjectileResource):
	resource = _resource
	$Sprite2D.texture = resource.texture
	
