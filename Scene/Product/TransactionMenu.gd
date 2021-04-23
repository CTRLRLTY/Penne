extends "res://Scene/Product/ManageProduct.gd"

const ProductCardScene = preload("res://Scene/Product/ProductCard.tscn")

var page_cache = {}
var product_cache = []
var amount_cache = {}

func _ready():
	if not pages.empty():
		if pages[-1].empty():
			pages.pop_back()
			
	connect("page_transition",self, "_on_page_transition")
	
func _show_page(products : Array) -> void:	
	for product in products:
		var product_card : Control = ProductCardScene.instance()
		var amount = amount_cache.get(product["name"], 0)
		product_cache.append(product)
		product_card.connect("amount_changed", self, "_on_Item_amount_changed")
		product_grid.add_child(product_card)
		product_card.change_attr(product, amount)
	
func _on_PayButton_pressed() -> void:
	pass # Replace with function body.
	
func _on_Item_amount_changed(product, amount) -> void:
	amount_cache[product] = amount
	print_debug("amount: ", amount_cache)
	
func _on_page_transition(current_page, next_page) -> void:
	#Poor man caching system rip
	page_cache[current_page] = {
		"amounts": amount_cache.duplicate(),
		"products": product_cache.duplicate()
		}
	
	print(next_page)
	if page_cache.has(next_page):
		amount_cache = page_cache[next_page]["amounts"]
	else:
		amount_cache.clear()
		product_cache.clear()
		
