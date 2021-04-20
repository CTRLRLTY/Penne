extends TextureRect

const MAX_GRID_CHILDREN = 6
const ProductItemScene : PackedScene = preload("res://Scene/Product/ProductItem.tscn")

export(NodePath) var ProductGridPath : NodePath
export(NodePath) var PageLabelPath : NodePath

var current_page = 0
var pages := []

onready var product_grid : GridContainer = get_node(ProductGridPath)
onready var page_label : Label = get_node(PageLabelPath)

func _ready():
	#This shit will be slow if we have a million products, but who cares.
	if Globals.resource_db:
		var acc := []
		#O(N) >= 1M = BAD!
		#This code makes me think of life and death every day
		for product in Globals.resource_db:
			acc.append(product)
			if acc.size() > 5:
				pages.append(acc.duplicate())
				acc.clear()
		
		pages.append(acc)
		_set_pagination(current_page, pages.size())
		_show_page(pages[current_page])

func _show_page(products) -> void:
	for product_node in product_grid.get_children():
		product_node.queue_free()
	
	yield(get_tree(), "node_removed")
	
	for product in products:
		var product_item = ProductItemScene.instance()	
		product_grid.add_child(product_item)
		product_item.change_attr(product)
		
func _set_pagination(current, maximum):
	page_label.text = "PAGE %s/%s" % [str(current+1), str(maximum)]

func _on_PrevPage_pressed():
	var prev_page = current_page - 1
	if not prev_page < 0 :
		current_page = prev_page
		_set_pagination(current_page, pages.size())
		_show_page(pages[current_page])

func _on_NextPage_pressed():
	var next_page = current_page + 1
	if pages.size() > next_page:
		current_page = next_page
		_set_pagination(current_page, pages.size())
		_show_page(pages[current_page])
