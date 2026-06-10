extends CanvasLayer

@onready var player = $"../Player"
@onready var move_joystick = $"Control/VBoxContainer2/VirtualJoystickPlus"

var use_joystick_on_pc := true

var move_active := false

func _ready():
	move_joystick.analogic_changed.connect(_on_move_changed)

@warning_ignore("unused_parameter")
func _on_move_changed(value, distance, angle, angle_clockwise, angle_counter):
	if not OS.has_feature("mobile") and not use_joystick_on_pc:
		return

	if distance > 0.15:
		move_active = true
		player.set_move_input(value)
	else:
		move_active = false
		player.set_move_input(Vector2.ZERO)
