extends Node

const EXPLOSION = preload("res://sounds/mixkit-sea-mine-explosion-1184.wav")
const PLAYER_EXPLOSION = preload("res://sounds/player_explosion.wav")
const ENEMY_EXPLOSION = preload("res://sounds/enemy_explosion.wav")
const LASER = preload("res://sounds/laser_sound.wav")
const BONUS = preload("res://sounds/bonus_01.wav")
const POWER_UP = preload("res://sounds/power_up.wav")
const COIN = preload("res://sounds/coin.wav")
const DEEP_IMPACT = preload("res://sounds/mixkit-space-impact-774.wav")
const PLAYER_HIT = preload("res://sounds/player_hit.wav")
const POWER_UP_BULLETS = preload("res://sounds/power_up_bullets.wav")

@onready var audio_players: Node = $AudioPlayers

func play_sound(sound, volume: int = 0):
	for audio_stream_player in audio_players.get_children() as Array[AudioStreamPlayer]:
		if not audio_stream_player.playing:
			audio_stream_player.stream = sound
			audio_stream_player.volume_db = volume
			audio_stream_player.play()
			break
