@tool
extends EditorPlugin

var button: Button

func _enter_tree() -> void:
	button = Button.new()
	button.text = "Sync Linter"
	button.tooltip_text = "Copy latest GDScript Linter plugin from source"
	button.pressed.connect(_on_sync_pressed)
	add_control_to_container(CONTAINER_TOOLBAR, button)

func _exit_tree() -> void:
	if button:
		remove_control_from_container(CONTAINER_TOOLBAR, button)
		button.queue_free()

func _on_sync_pressed() -> void:
	var script_path = ProjectSettings.globalize_path("res://scripts/tools/sync-linter-plugin.ps1")
	var output: Array = []

	print("[Plugin Sync] Running sync script...")
	var exit_code = OS.execute("powershell", ["-ExecutionPolicy", "Bypass", "-File", script_path], output, true)

	for line in output:
		print(line)

	if exit_code == 0:
		print("[Plugin Sync] Sync complete!")
		EditorInterface.get_resource_filesystem().scan()
	else:
		push_error("[Plugin Sync] Failed with exit code: %d" % exit_code)
