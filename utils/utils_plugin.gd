@tool
extends EditorPlugin

func _enter_tree():
	print("Utils plugin loaded!")

func _exit_tree():
	print("Utils plugin unloaded!")
