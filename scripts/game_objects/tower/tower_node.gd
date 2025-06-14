extends Area2D

@onready var working_state_machine = get_node('../WorkingStateMachine')

signal mouse_still_inside

func _ready() -> void:
	connect("mouse_still_inside", _on_mouse_still_inside)

func _process(_delta) -> void:
	var mouse_position = get_global_mouse_position()
	if mouse_position.distance_to(global_position) < 16:
		emit_signal("mouse_still_inside")

func hover_handler():
	if not working_state_machine.current_state_name in ["Idle", "Unreachable"]:
		return
	# TODO: check game_store is connecting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		working_state_machine.node_switch_to("Selected")
	else:
		if working_state_machine.last_stable_state_name == "Unreachable":
			return
		working_state_machine.node_switch_to("Hovering")

func _on_mouse_still_inside() -> void:
	hover_handler()

func _on_mouse_entered() -> void:
	hover_handler()

func _on_mouse_exited() -> void:
	if working_state_machine.get_state_name() in ["Hovering", "Selected"]:
		working_state_machine.node_switch_to_last_stable_state()
