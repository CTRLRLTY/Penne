extends Node

const LoginScene = preload("res://Scene/Login/Login.tscn")
const MainMenuScene = preload("res://Scene/MainMenu.tscn")

const NewProductScene = preload("res://Scene/Product/NewProduct.tscn")
const EditProductScene = preload("res://Scene/Product/EditProduct.tscn")
const ManageProductScene = preload("res://Scene/Product/ManageProduct.tscn")

const user_file_path = "user://users.json"
const rsc_file_path = "user://resources.json"
const image_dir_path = "user://images/"

var user_db 
var resource_db
var image_plugin

func _ready():
	print_debug(OS.get_user_data_dir())
	var dir = Directory.new()
	
	if not dir.dir_exists(image_dir_path):
		dir.make_dir(image_dir_path)
	
	user_db = _open_file(user_file_path)
	resource_db = _open_file(rsc_file_path)
	
	if Engine.has_singleton("GodotGetImage"):
		image_plugin = Engine.get_singleton("GodotGetImage")
		
	print_debug("user_db: ", user_db)
	print_debug("resource_db: ", resource_db)
	OS.request_permissions()
		

func _open_file(file_path : String):
	var file = File.new()
	var db = null
	
	if file.file_exists(file_path):
		file.open(file_path, File.READ)
		db = JSON.parse(file.get_as_text()).result
		file.close()
		
	return db
		


		
