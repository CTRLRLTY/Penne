extends Node

const LoginScene = preload("res://Scene/Login/Login.tscn")
const MainMenuScene = preload("res://Scene/MainMenu.tscn")
const PaymentMenuScene = preload("res://Scene/PaymentMenu.tscn")
const InvoiceMenuScene = preload("res://Scene/InvoiceMenu.tscn")

const NewProductScene = preload("res://Scene/Product/NewProduct.tscn")
const EditProductScene = preload("res://Scene/Product/EditProduct.tscn")
const ManageProductScene = preload("res://Scene/Product/ManageProduct.tscn")
const TransactionMenuScene = preload("res://Scene/Product/TransactionMenu.tscn")

const LaporanMenuScene = preload("res://Scene/Laporan/LaporanMenu.tscn")

const user_file_path = "user://users.json"
const rsc_file_path = "user://resources.json"
const trans_file_path = "user://transactions.json"
const report_file_path = "user://reports.json"
const image_dir_path = "user://images/"

var _year : String
var _month : String
var _week : String
var _day : String

var date : Dictionary setget , get_date

var user_db setget set_user_db
var resource_db 
var trans_db setget set_trans_db
var report_db setget set_report_db 
var image_plugin

func _ready():
	
	_set_date()
	print_debug(OS.get_user_data_dir())
	var dir = Directory.new()
	
	if not dir.dir_exists(image_dir_path):
		dir.make_dir(image_dir_path)
	
	self.user_db = _open_file(user_file_path)
	self.resource_db = _open_file(rsc_file_path)
	self.trans_db = _open_file(trans_file_path)
	self.report_db = _open_file(report_file_path)
	
	if Engine.has_singleton("GodotGetImage"):
		image_plugin = Engine.get_singleton("GodotGetImage")
		
	OS.request_permissions()
		

func _open_file(file_path : String):
	var file := File.new()
	var db := {}
	
	if file.file_exists(file_path):
		file.open(file_path, File.READ)
		db = JSON.parse(file.get_as_text()).result
		file.close()
		
	return db

func _save_db(db : Dictionary, path: String):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(to_json(db))
	file.close()
	
func _set_date():
	var date = OS.get_date()

	_year = str(date["year"])
	_month = str(date["month"])
	_week = str(floor((date["day"] - 1) / 7 + 1))
	_day = str(date["day"])
	
func get_date():
	_set_date()
	return {
	"year": _year,
	"month": _month,
	"week": _week,
	"day": _day
	}
	
func _new_report(trans: Dictionary, date: String, stamp: String) -> void:
	if report_db[date].has(stamp):
		report_db[date][stamp].price += trans.price
		report_db[date][stamp].modal += trans.modal
		for item in trans.sold.keys():
			if report_db[date][stamp].sold.has(item):
				report_db[date][stamp].sold[item] += trans.sold[item]
			else:
				report_db[date][stamp].sold[item] = trans.sold[item]
	else:
		report_db[date][stamp] = trans
		
func set_user_db(new_db: Dictionary) -> void:
	user_db = new_db
	_save_db(user_db, user_file_path)
	
func set_trans_db(new_db: Dictionary) -> void:	
	if new_db.empty():
		
		trans_db = {
			_year: {
				_month: {
					_week: {
						_day: {}
					}
				}
			}
		}
	else:
		trans_db = new_db
	
	_save_db(trans_db, trans_file_path)

func set_report_db(new_db: Dictionary) -> void:
	if new_db.empty():
		report_db = {
			"year": {},
			"month": {},
			"week": {},
			"day": {}
		}
	else:
		report_db = new_db
	_save_db(report_db, report_file_path)
	
func add_user(email: String, fullname: String, password: String) -> void: 
	user_db[email] = {
		"fullname": fullname,
		"password": password
	}
	_save_db(user_db, user_file_path)
	
func user_valid(email: String, password: String) -> bool:
	if user_db.has(email):
		return user_db[email]["password"] == password
	else:
		return false
	
func new_trans(trans: Dictionary) -> void:
	_set_date()
	
	_new_report(trans.duplicate(true), "year", _year)
	_new_report(trans.duplicate(true), "month", _month)
	_new_report(trans.duplicate(true), "week", _week)
	_new_report(trans.duplicate(true), "day", _day)
	_save_db(report_db, report_file_path)
	
	trans_db[_year] = trans_db.get(_year, {})
	trans_db[_year][_month] = trans_db[_year].get(_month,{})
	trans_db[_year][_month][_week] = trans_db[_year][_month].get(_week, {})
	trans_db[_year][_month][_week][_day] = trans_db[_year][_month][_week].get(_day, {})
	trans_db[_year][_month][_week][_day][str(OS.get_system_time_msecs())] = trans
	_save_db(trans_db, trans_file_path)
	

	
	

	

