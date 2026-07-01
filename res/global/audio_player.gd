extends AudioStreamPlayer

const menu_music = preload("res://res/asset/sound/bgm4.mp3")
const storyBGM = preload("res://res/asset/sound/bgm5.mp3")
const btn7 = preload("res://res/asset/sound/sfx/btn7.mp3")
const bit1 = preload("res://res/asset/sound/8 bit 2.mp3")
const bit2 = preload("res://res/asset/sound/8 bit 3.mp3")
const bit3 = preload("res://res/asset/sound/8 bit 4.mp3")
const bit4 = preload("res://res/asset/sound/bgm3.mp3")

const level_music = [
	bit1,
	bit2,
	bit3,
	bit4
]
var last_music := -1

func _ready():
	randomize()
	finished.connect(_on_music_finished)

func _on_music_finished():
	play()
	
func _play_random_lvl_music():
	var index = randi_range(0, level_music.size() - 1)

	while level_music.size() > 1 and index == last_music:
		index = randi_range(0, level_music.size() - 1)

	last_music = index
	_play_music(level_music[index])

func _play_music(music: AudioStream, volume = -10.0):
	if !finished.is_connected(_on_music_finished):
		finished.connect(_on_music_finished)

	if stream == music and playing:
		return

	stream = music
	volume_db = volume
	play()
	
func _play_music_menu():
	_play_music(menu_music)

func _play_lvl_music(lvl_music):
	_play_music(lvl_music)

func _play_story_music():
	_play_music(storyBGM)

func _play_fx(stream: AudioStream, volume = 0.0) :
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()
	
func _play_fx_btn7():
	_play_fx(btn7)
	
func _mute_music():
	volume_db = -80.0;
	print("muted");

func _non_mute_music():
	volume_db = -10.0;
	print("not muted")
