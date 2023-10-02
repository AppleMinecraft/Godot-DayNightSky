## This is a plugin for godot 4 that adds dynamic sky with day and night cycle with stars and lots of customization.
@tool
extends WorldEnvironment
class_name DayNightSky

## Default value (1440 = 24 * 60) is the number of minutes in a day.
@export var MaxSeconds : int = 1440
## Number of seconds that gets increased in a second.
@export var TimeStep : int = 1
## If true increases time. If false freezes time.
@export var SimulateTime: bool = false
## The current time in seconds.
@export var time: float = 0

@onready var sunMoon: Node3D = $Lighting

func _ready() -> void:
	if !Engine.is_editor_hint():
		SimulateTime = true

func _calculateRotation() -> void: 
	var remapedTime: float = remap(time, 0.0, MaxSeconds, 0.0, 1.0)
	var rotation: float = deg_to_rad(remapedTime * 360)
	$Lighting.rotation.x = rotation
	0.000694444

func _process(delta: float) -> void:
	if SimulateTime:
		time += delta * TimeStep
		if time > MaxSeconds:
			time = 0.0
	_calculateRotation()
