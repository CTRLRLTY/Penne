extends "res://Scene/Product/NewProduct.gd"

var id
var image_path := ""

func _set_product(product : Dictionary):
	product.id = id
	Globals.resource_db[id] = product
	product.imagePath = image_path

func bootload(attr):
	print_debug("Starting bootloader...")
	image_rect.texture = load(attr.imagePath)
	
	self.id = attr.id
	self.image_path = attr.imagePath
	
	name_prop.prop_value = attr.name
	amount_prop.prop_value = attr.amount
	modal_prop.prop_value = attr.modal
	price_prop.prop_value = attr.price
