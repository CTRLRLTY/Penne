extends "res://Scene/Product/ManageProduct.gd"

const ProductCardScene = preload("res://Scene/Product/ProductCard.tscn")

var page_cache = {}
var product_cache = []
var amount_cache = {}

func _bootload(carry):
	current_page = carry["page"]
	page_cache = carry["cache"]
	amount_cache = page_cache[current_page]["amounts"]

func _ready():
	if not pages.empty():
		if pages[-1].empty():
			pages.pop_back()
	
	
func _show_page(products : Array) -> void:	
	for product in products:
		var product_card : Control = ProductCardScene.instance()
		var amount = amount_cache.get(product["name"], 0)
		product_cache.append(product)
		product_card.connect("amount_changed", self, "_on_Item_amount_changed")
		product_grid.add_child(product_card)
		product_card.change_attr(product, amount)
		
func _cache() -> void:
	#Poor man caching system rip
	page_cache[current_page] = {
		"amounts": amount_cache.duplicate(),
		"products": product_cache.duplicate()
		}
	
func _on_TransactionMenu_page_transition(current_page: int, next_page: int) -> void:
	_cache()
	
	if page_cache.has(next_page):
		amount_cache = page_cache[next_page]["amounts"]
	else:
		amount_cache.clear()
		product_cache.clear()
		
func _on_PayButton_pressed() -> void:
	_cache()
	var carry = {
		"page": current_page,
		"cache": page_cache
	}
	SceneChanger.change_scene(Globals.PaymentMenuScene, "fade", carry)
	
func _on_Item_amount_changed(product: String, amount: int) -> void:
	amount_cache[product] = amount
	
