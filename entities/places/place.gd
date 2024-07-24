extends CharacterBody2D

class_name Place

var resource: PlaceResource: set = set_resource

func set_resource(_resource: PlaceResource):
	var sprite = $Sprite2D
	
	resource = _resource
	sprite.texture = resource.texture 
