extends TouchScreenButton

@onready var anim: AnimationPlayer = $AnimationPlayer
	
func reset_set(num) :
	anim.play("set" + str(num))

func btn_press() :
	if anim.is_playing():
		anim.stop()
	AudioPlayer._play_fx_btn7()
