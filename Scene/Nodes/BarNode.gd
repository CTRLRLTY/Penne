tool

extends Panel

export(String) var BarName := "name" setget set_bar_name
export(int) var Amount := 0 setget set_amount

onready var name_label = $Label
onready var amount_label = $Amount


func _ready():
	name_label.text = BarName
	amount_label.text = str(Amount)

func set_bar_name(name: String) -> void:
	BarName = name
	if Engine.editor_hint:
		$Label.text = BarName

func set_amount(amount: int) -> void:
	Amount = amount
	if Engine.editor_hint:
		$Amount.text = str(amount)
