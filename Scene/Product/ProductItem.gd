extends PanelContainer

onready var product_thumbnail = $MarginContainer/HBoxContainer/Image
onready var product_name = $MarginContainer/HBoxContainer/VBoxContainer/Name
onready var product_stock = $MarginContainer/HBoxContainer/VBoxContainer/Stock

var properties : Dictionary

func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			SceneChanger.change_scene(Globals.EditProductScene, "fade", properties)

func change_attr(attr : Dictionary):
	properties = attr
	product_thumbnail.texture = load(attr.imagePath)
	
	product_name.text = attr.name
	product_stock.text = attr.amount
