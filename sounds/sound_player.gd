extends Node

const PLAYER_EXPLOSION = preload("res://sounds/player_explosion.wav")
const ENEMY_EXPLOSION = preload("res://sounds/enemy_explosion.wav")
const COIN = preload("res://sounds/coin_collect.wav")
const PLAYER_HIT = preload("res://sounds/player_hit.wav")
const POWER_UP_BULLETS = preload("res://sounds/bullets_power_up.wav")
const HYPER_LEVEL_UP = preload("res://sounds/hyper_level_up.wav")
const UI_ACTION = preload("res://sounds/ui_action.wav")

@onready var audio_players: Node = $AudioPlayers

func play_sound(sound, volume: int = 0):
	for audio_stream_player in audio_players.get_children() as Array[AudioStreamPlayer]:
		if not audio_stream_player.playing:
			audio_stream_player.stream = sound
			audio_stream_player.volume_db = volume
			audio_stream_player.play()
			break
