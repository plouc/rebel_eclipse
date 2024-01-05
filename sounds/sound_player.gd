extends Node

const PLAYER_EXPLOSION = preload("res://sounds/player_explosion.wav")
const ENEMY_EXPLOSION = preload("res://sounds/enemy_explosion.wav")
const COIN = preload("res://sounds/coin_collect.wav")
const PLAYER_HIT = preload("res://sounds/player_hit.wav")
const POWER_UP_BULLETS = preload("res://sounds/bullets_power_up.wav")
const HYPER_LEVEL_UP = preload("res://sounds/hyper_level_up.wav")
const UI_ACTION = preload("res://sounds/ui_action.wav")

const VOLUME_MUTED: float = -40.0

@onready var audio_players: Node = $AudioPlayers

var player_by_name = {}

func get_free_player():
	for audio_stream_player in audio_players.get_children() as Array[AudioStreamPlayer]:
		if not audio_stream_player.playing:
			return audio_stream_player

	# print("No free audio player available")

	return null

func play(stream: AudioStream, volume: float = 0.0):
	var player = get_free_player()
	if not player:
		return
	
	player.stream = stream
	player.volume_db = volume
	player.play()
	
	return player

func fade_in(player: AudioStreamPlayer, volume: float = 0.0, duration: float = 1.0):
	var fade_in_tween = create_tween().set_ease(Tween.EASE_OUT)
	fade_in_tween.tween_property(player, "volume_db", volume, duration).from_current()

	await fade_in_tween.finished

func fade_out(player: AudioStreamPlayer, duration: float = 1.0):
	var fade_out_tween = create_tween().set_ease(Tween.EASE_IN)
	fade_out_tween.tween_property(player, "volume_db", VOLUME_MUTED, duration).from_current()

	await fade_out_tween.finished

func play_for_duration(
	stream: AudioStream,
	duration: float,
	volume: float = 0.0,
	fade_in_duration: float = 0.0,
	fade_out_duration: float = 0.0
):
	var player = get_free_player()
	if not player:
		return

	player.stream = stream
	if fade_in_duration <= 0.0:
		player.volume_db = volume
	else:
		player.volume_db = VOLUME_MUTED
	
	player.play()
	
	if fade_in_duration > 0.0:
		await fade_in(player, volume, fade_in_duration)
	
	var timer = get_tree().create_timer(duration)
	await timer.timeout
	
	if fade_out_duration > 0.0:
		await fade_out(player, fade_out_duration)

	player.stop()

func play_named(sound_name: String, stream: AudioStream, volume: int = 0):
	var player = play(stream, volume)
	if not player:
		return

	player_by_name[sound_name] = player
	
	return player

func fade_transition(
	sound_name: String,
	stream: AudioStream,
	duration: float = 4.0,
	volume: float = 0.0
):
	if sound_name not in player_by_name:
		# print("Player not found")
		return

	var player = player_by_name[sound_name]
	
	await fade_out(player, duration / 2.0)

	player.stop()
	player.stream = stream
	player.volume_db = -40.0
	player.play()
	
	await fade_in(player, volume, duration / 2.0)

func stop_all():
	for audio_stream_player in audio_players.get_children() as Array[AudioStreamPlayer]:
		audio_stream_player.stop()
	
	player_by_name = {}
