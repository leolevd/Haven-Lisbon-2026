extends Control


func _on_start_pressed() -> void:
	print("Start Game pressed")
	get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	print("Settings pressed")
	pass # Replace with function body.


func _on_button_quit_pressed() -> void:
	print("Quit pressed")
	get_tree().quit()
	pass # Replace with function body.
