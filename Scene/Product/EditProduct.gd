extends "res://Scene/Product/NewProduct.gd"

var id
var image_path := ""

func _set_product(product : Dictionary):
	product.id = id
	Globals.resource_db[id] = product
	product.imagePath = image_path

func bootload(properties):
	print_debug("Starting bootloader...")
	var image = Image.new()
	var image_texture = ImageTexture.new()
	
	image.load(properties.imagePath)
	yield(get_tree(), "idle_frame")
	image_texture.create_from_image(image)
	image_rect.texture = image_texture
	
	self.id = properties.id
	self.image_path = properties.imagePath
	
	name_prop.prop_value = properties.name
	amount_prop.prop_value = properties.amount
	modal_prop.prop_value = properties.modal
	price_prop.prop_value = properties.price
