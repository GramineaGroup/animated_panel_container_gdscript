@tool
extends EditorPlugin
const PLUGIN_NAME = "animated_panel_container"

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type(PLUGIN_NAME, "PanelContainer", preload(PLUGIN_NAME + ".gd"), preload("icon.png"))
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type(PLUGIN_NAME)
	pass

## Get the current path of the plugin
func get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir()
