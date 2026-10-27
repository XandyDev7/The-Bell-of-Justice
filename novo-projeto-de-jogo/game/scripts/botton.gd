extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_optionsbutton_pressed() -> void:
	print("options pressed")
func _on_creditsbutton_pressed() -> void:
	print ("credits pressed")


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game/introdução.tscn")
	print("start pressed")
	pass

func _on_credits_pressed() -> void:
		print ("credits pressed")

		pass # Replace with function body.
