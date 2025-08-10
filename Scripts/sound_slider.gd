extends HSlider

@export var audio_bus_name := "Master"
var audio_bus_id

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	if audio_bus_id == -1:
		push_error("Audio bus '%s' not found!" % audio_bus_name)

func _on_value_changed(value: float) -> void:
	if audio_bus_id != -1:
		var db = linear_to_db(value)
		AudioServer.set_bus_volume_db(audio_bus_id, db)
