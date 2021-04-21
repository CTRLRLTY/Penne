extends TextureRect

export(NodePath) var ImageRectPath : NodePath
export(NodePath) var EditImageButtonPath : NodePath
export(NodePath) var NamePropPath : NodePath
export(NodePath) var AmountPropPath : NodePath 
export(NodePath) var ModalPropPath : NodePath
export(NodePath) var PricePropPath : NodePath
export(NodePath) var SaveButtonPath : NodePath

onready var image_rect : TextureRect = get_node(ImageRectPath)
onready var edit_image_button : Button = get_node(EditImageButtonPath)
onready var name_prop : Container = get_node(NamePropPath)
onready var amount_prop : Container = get_node(AmountPropPath)
onready var modal_prop : Container = get_node(ModalPropPath)
onready var price_prop : Container = get_node(PricePropPath)
onready var save_button : Button = get_node(SaveButtonPath)

onready var pressed_amount = 0

func _ready():
	if Globals.image_plugin:
		Globals.image_plugin.connect("image_request_completed", self, "_on_image_receive")

func _open_gallery():
	if Globals.image_plugin:
		Globals.image_plugin.getGalleryImage()
	else:
		push_error("image plugin not found")

func _set_product(product : Dictionary):
	product["id"] = Globals.resource_db.size()
	Globals.resource_db.append(product)
	product["imagePath"] = Globals.image_dir_path + str(Globals.resource_db.size() - 1) + ".res"
	
func _on_image_receive(images: Dictionary):
	for image in images.values():
		var current_image = Image.new()
		current_image.load_jpg_from_buffer(image)
		yield(get_tree(), "idle_frame")
		var image_texture := ImageTexture.new()
		image_texture.create_from_image(current_image, 0)
		image_rect.texture = image_texture
	
	if image_rect.texture:
		edit_image_button.hide()
		image_rect.show()
	else:
		edit_image_button.show()
		image_rect.hide()
		
func _on_SaveButton_pressed():
	#THIS CODE IS DUMB. TOO BAD
	save_button.disabled = true
	var file = File.new()
	var product = {
		"name": name_prop.prop_value,
		"amount": amount_prop.prop_value,
		"price": price_prop.prop_value,
		"modal": modal_prop.prop_value,
		"imagePath": "res://asset/godot.png"
	}

	var bitmask = ResourceSaver.FLAG_COMPRESS
	if Globals.resource_db:
		_set_product(product)
	else:
		product["id"] = 0
		Globals.resource_db = [product]
		product["imagePath"] = Globals.image_dir_path + "0.res"
		
	if image_rect.texture:
		ResourceSaver.save(product["imagePath"], image_rect.texture, bitmask)
	else:
		product["imagePath"] = "res://asset/godot.png"
	
	file.open(Globals.rsc_file_path, File.WRITE)
	file.store_string(to_json(Globals.resource_db))
	file.close()
	print_debug("Product Saved: ", Globals.resource_db[product["id"]])
	SceneChanger.change_back("fade")
	
func _on_EditImageButton_pressed():
	_open_gallery()
		
func _on_ImageRect_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			_open_gallery()

func _on_BackButton_pressed():
	SceneChanger.change_back("fade")
