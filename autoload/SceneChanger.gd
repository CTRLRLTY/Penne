extends CanvasLayer

var current_scene : NodePath setget set_current_scene
var previous_scene : NodePath

onready var animation_player : AnimationPlayer = $AnimationPlayer

func set_current_scene(path: NodePath):
	previous_scene = current_scene
	current_scene = path
	
func change_scene(new_scene: NodePath, animation: String):
	set_current_scene(new_scene)
	animation_player.play(animation)
	
func back(animation: String):
	set_current_scene(previous_scene)
	animation_player.play(animation)
	
func _transition():
# warning-ignore:return_value_discarded
	get_tree().change_scene(current_scene)	
	
