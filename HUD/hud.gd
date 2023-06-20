extends Control

func get_lives(lives:int):
	if lives == 5:
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

func get_act_life(amount:int):
	$LIFE/LifeAct.value = amount
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_lives(5)
	get_act_life(100)
