extends "res://Scene/Product/ManageProduct.gd"

const ProductCardScene = preload("res://Scene/Product/ProductCard.tscn")

var page_cache = {}
var amount_cache = [0,0,0,0,0,0]
var price_cache = [0,0,0,0,0,0]
func _ready():
	
	
	if not pages.empty():
		if pages[-1].empty():
			pages.pop_back()
			
	connect("page_transition",self, "_on_page_transition")
	


func _show_page(products : Array) -> void:	
	#this code is literally a copy paste but paste from the parent but WHO CARES
	#LET IT BE WET BABYYYYYYYY
	for product_node in product_grid.get_children():
		product_node.queue_free()
	
	yield(get_tree(), "idle_frame")
	
	var ctr = 0
	
	for product in products:
		var product_card : Control = ProductCardScene.instance()
		
		price_cache[ctr] = product["price"]
		product_card.connect("amount_changed", self, "_on_Item_amount_changed")
		product_grid.add_child(product_card)
		product_card.change_attr(product, amount_cache[ctr])
		ctr += 1
	
func _on_PayButton_pressed() -> void:
	pass # Replace with function body.
	
func _on_Item_amount_changed(id, amount) -> void:
	amount_cache[int(id) % 6] = amount
	
func _on_page_transition(current_page, next_page) -> void:
	#Poor man caching system rip
	page_cache[current_page] = {
		"amounts": amount_cache.duplicate(),
		"prices": price_cache.duplicate()
		}
	
	print(next_page)
	if page_cache.has(next_page):
		amount_cache = page_cache[next_page].amounts
		price_cache = page_cache[next_page].prices
	else:
		amount_cache = [0,0,0,0,0,0]
		price_cache = [0,0,0,0,0,0]
		
	print(page_cache)
