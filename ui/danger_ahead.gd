extends Control

const AUDIO_STREAM = preload("res://sounds/emergency_alarm.wav")

func _ready():
	SoundPlayer.play_for_duration(AUDIO_STREAM, 8.0, -3.0, 0.0, 4.0)
