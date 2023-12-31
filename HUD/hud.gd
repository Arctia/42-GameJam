extends Control

func get_lives(lives:int):
	if lives >= 5:
		$LIFE/Life1.visible = true
		$LIFE/Life2.visible = true
		$LIFE/Life3.visible = true
		$LIFE/Life4.visible = true
	elif lives == 4:
		$LIFE/Life1.visible = false
		$LIFE/Life2.visible = true
		$LIFE/Life3.visible = true
		$LIFE/Life4.visible = true
	elif lives == 3:
		$LIFE/Life1.visible = false
		$LIFE/Life2.visible = false
		$LIFE/Life3.visible = true
		$LIFE/Life4.visible = true
	elif lives == 2:
		$LIFE/Life1.visible = false
		$LIFE/Life2.visible = false
		$LIFE/Life3.visible = false
		$LIFE/Life4.visible = true
	elif lives <= 1:
		$LIFE/Life1.visible = false
		$LIFE/Life2.visible = false
		$LIFE/Life3.visible = false
		$LIFE/Life4.visible = false

func get_ashes(amount:int):
	$LIFE/LifeAct.value = amount

func disable_self():
	self.queue_free()

func reset_time():
	$TimerValue.reset(0)

func get_time():
	return $TimerValue.text

func get_time_secs() -> int:
	return int($TimerValue.time)
