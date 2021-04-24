extends CanvasLayer

signal completed

var current_scene : PackedScene setget set_current_scene
var previous_scene : PackedScene
var carry
var cache

onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	var packer = PackedScene.new()
	yield(get_tree(), "idle_frame")
	packer.pack(get_tree().current_scene)
	set_current_scene(packer)
	

func set_current_scene(scene : PackedScene):
	previous_scene = current_scene
	current_scene = scene
	
func change_scene(new_scene: PackedScene, animation: String, args = null):
	self.carry = args
	
	if args:
		cache = null
		
	set_current_scene(new_scene)
	animation_player.play(animation)
	
func change_back(animation: String, args = null, one_time := false):
	if cache != null:
		args = cache
		if one_time:
			cache = null
	change_scene(previous_scene, animation, args)
	
func _transition():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(current_scene)	
	yield(get_tree().current_scene, "tree_exited")
	yield(get_tree(), "node_added")
	if carry != null:
		if get_tree().current_scene.has_method("bootload"):
			get_tree().current_scene.bootload(carry)
			
func _pause_tree(condition : bool):
	get_tree().set_pause(condition)
	
