extends TextureRect

const ProductItemScene : PackedScene = preload("res://Scene/Product/ProductItem.tscn")
const AddProductItemScene : PackedScene = preload("res://Scene/Product/AddProductItem.tscn")

signal page_transition (current_page, next_page)

export(NodePath) var ProductGridPath : NodePath
export(NodePath) var PageLabelPath : NodePath

var current_page = 0
var pages := []
onready var resource_db = Globals.resource_db

onready var product_grid : GridContainer = get_node(ProductGridPath)
onready var page_label : Label = get_node(PageLabelPath)

func _ready():
	if resource_db:
		_index_pages()
		
		#This line of code generates weird ass error when using 
		#SceneChanger.change_back() which I don't know what/why. 
		#But the app still works. Fuck my life.
		yield(get_tree(), "idle_frame")
			
		_set_pagination(current_page, pages.size())
		_show_page(pages[current_page])
	else:
		_set_pagination(current_page, 1)
		_show_page([])

	
func _index_pages():
	#This code makes me think of life and death every day
	#GOTTA GO FAST YEEEEEEEEEEEEEEEEEEEEEEEEEET
	var acc := []
	#This shit will be slow if we have a million products, but who cares.
	for product in resource_db:
		acc.append(product)
		if acc.size() > 5:
			pages.append(acc.duplicate())
			acc.clear()
	
	pages.append(acc)

func _show_page(products : Array) -> void:
	for product_node in product_grid.get_children():
		product_node.queue_free()
	
	#I put this code for a reason, but now I forgot why.
	#Just know that this shit fix some bugs?
	yield(get_tree(), "node_removed")
	
	for product in products:
		var product_item : Control = ProductItemScene.instance()
		product_item.connect("gui_input", self, "_on_Product_gui_input")
		product_grid.add_child(product_item)
		product_item.change_attr(product)
	
	if products.size() < 6:
		var add_product = AddProductItemScene.instance()
		add_product.connect("gui_input", self, "_on_Product_gui_input")
		product_grid.add_child(add_product)
		
func _set_pagination(current, maximum):
	page_label.text = "PAGE %s/%s" % [str(current+1), str(maximum)]
	
func bootload(page : int):
	current_page = page

func _on_PrevPage_pressed():
	var prev_page = current_page - 1
	emit_signal("page_transition", current_page, prev_page)
	if not prev_page < 0 :
		current_page = prev_page
		_set_pagination(current_page, pages.size())
		_show_page(pages[current_page])

func _on_NextPage_pressed():
	var next_page = current_page + 1
	emit_signal("page_transition", current_page, next_page)
	if pages.size() > next_page:
		current_page = next_page
		_set_pagination(current_page, pages.size())
		_show_page(pages[current_page])
		
func _on_Product_gui_input(event):
	#This is a bloated hack. TOO BAD.
	if event is InputEventScreenTouch:
		if event.pressed:
			SceneChanger.cache = current_page

func _on_BackButton_pressed() -> void:
	SceneChanger.change_scene(Globals.MainMenuScene, "fade")
