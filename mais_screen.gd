extends Control

@onready var main_buttons: VBoxContainer = $Main_Buttons
@onready var options: Panel = $Options


func _ready():
	main_buttons.visible = true
	options.visible = false
	
func _on_start_pressed() -> void:
	$AudioStreamPlayer.stream = load("res://click.mp3")
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.




func _on_settings_pressed() -> void:
	print("Settings pressed")
	main_buttons.visible = false
	options.visible = true
	pass # Replace with function body.


func _on_button_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_settings_exit_pressed() -> void:
	main_buttons.visible = true
	options.visible = false
	pass # Replace with function body.
