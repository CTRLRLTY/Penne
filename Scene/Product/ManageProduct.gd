extends TextureRect

const MAX_GRID_CHILDREN = 6
const ProductItemScene : PackedScene = preload("res://Scene/Product/ProductItem.tscn")

export(NodePath) var ProductGridPath : NodePath

onready var product_grid : GridContainer = get_node(ProductGridPath)

func _ready():
	if Globals.resource_db:
		for product in Globals.resource_db:
			var product_item = ProductItemScene.instance()	
			product_grid.add_child(product_item)
			product_item.change_attr(product)
