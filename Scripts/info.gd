extends Control

onready var original = $original_info
onready var remake = $remake_info
onready var translation = $translation_info

func _ready():
	original.show()
	remake.hide()
	translation.hide()

func _on_Button_pressed():
	if original.visible == true:
		original.hide()
		remake.show()
	elif remake.visible == true:
		translation.show()
		remake.hide()
	elif translation.visible == true:
		original.show()
		translation.hide()
		self.hide()


func _on_engine_pressed():
	OS.shell_open("https://godotengine.org")

func _on_github_pressed():
	OS.shell_open("https://github.com/DarkPro1337/arcomage")

func _on_trello_pressed():
	OS.shell_open("https://trello.com/b/nQuzlNk5/arcomage-remake")

func _on_itch_pressed():
	OS.shell_open("https://darkpro1337.itch.io/arcomage")

func _on_gamejolt_pressed():
	OS.shell_open("https://gamejolt.com/games/arcomage/537808")

func _on_bmc_pressed():
	OS.shell_open("https://www.buymeacoffee.com/darkpro1337")

func _on_patreon_pressed():
	OS.shell_open("https://patreon.com/darkpro1337")

func _on_kofi_pressed():
	OS.shell_open("https://ko-fi.com/darkpro1337")

func _on_author_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		OS.shell_open("https://darkpro1337.github.io")

func _on_author_mouse_entered():
	$remake_info/text/author.modulate = Color("ff993f")

func _on_author_mouse_exited():
	$remake_info/text/author.modulate = Color("ffffff")
