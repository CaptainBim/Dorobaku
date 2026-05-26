extends TouchScreenButton

@onready var sprite: Sprite2D = $Sprite2D

func reset_set(num):
	sprite.frame = num

func btn_press():
	AudioPlayer._play_fx_btn7()
