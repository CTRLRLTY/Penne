tool

extends VBoxContainer

enum INPUT_TYPE {STRING = TYPE_STRING, INT = TYPE_INT}

export(StyleBoxFlat) var PanelContainerStyle : StyleBoxFlat setget set_panel_style
export(String) var NameText := "Name" setget set_name_text
export(INPUT_TYPE) var input_type := TYPE_STRING setget set_input_type
export(bool) var editable := true setget set_editable

onready var name_label : Label = $NameLabel
onready var input_edit : LineEdit = $PanelContainer/MarginContainer/InputEdit
onready var panel_container : PanelContainer = $PanelContainer

var _input_value

func _ready() -> void:
	_bootstrap()
	
func _bootstrap():
	match input_type:
		TYPE_INT:
			_input_value = "0"
			input_edit.placeholder_text = "0"
		TYPE_STRING:
			_input_value = ""
			input_edit.placeholder_text = ""
		
	$NameLabel.text = NameText
	$PanelContainer["custom_styles/panel"] = PanelContainerStyle
	$PanelContainer/MarginContainer/InputEdit.editable = editable
	
func set_editable(flag : bool):
	editable = flag
	if Engine.editor_hint:
		_bootstrap()
	
func set_input_type(type : int) -> void:
	input_type = type
	if Engine.editor_hint:
		_bootstrap()
	
func set_name_text(new_text : String) -> void:
	NameText = new_text
	if Engine.editor_hint:
		_bootstrap()

func set_panel_style(style : StyleBoxFlat) -> void:
	PanelContainerStyle = style
	if Engine.editor_hint:
		_bootstrap()
		
func _on_InputEdit_text_changed(new_text: String) -> void:
	if input_type == TYPE_INT:
		if not new_text.is_valid_integer():
			if new_text.empty():
				new_text = "0"
				input_edit.text = ""
			else:
				input_edit.text = _input_value
				new_text = _input_value
	_input_value = new_text

