extends "res://Scene/Product/NewProduct.gd"

var attribute

func _ready():
	if attribute:
		image_rect.texture = load(attribute.imagePath)	
		
		name_prop.prop_value = attribute.name
		amount_prop.prop_value = attribute.amount
		modal_prop.prop_value = attribute.modal
		price_prop.prop_value = attribute.price

func _set_product(product : Dictionary):
	product.id = attribute.id
	Globals.resource_db[attribute.id] = product
	product.imagePath = attribute.imagePath

func bootload(attribute):
	print_debug("Starting bootloader...")
	self.attribute = attribute
	
