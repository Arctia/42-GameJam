extends CharacterBody2D

@warning_ignore("narrowing_conversion")

signal setup_ashes(total_ash, current_ash)
signal consume_ashes(new_value)

const JUMP_FORCE_STEPS : float = 5.

@export var ACC:float = 30
@export var MAX_SPEED:float = 200
@export var JUMP:float = -500

var FRICTION:float
var moving:bool = false
var idle:float = 0.0

@onready var sprite = $Sprite2D
@onready var eyes = $Eyes
@onready var collisionShape = $CollisionShape2D
@onready var worldChecker = $WorldChecker

@export var ashes_full:float = 100000
#@export var ashes_amount:float = 100000

@export var spike_damage:float = 10.
@export var vs_wind:float = 100

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity") *1.5
var is_jumping:bool = false : 
	set(value) :
		is_jumping = value
var is_ducking:bool = false
var can_fall:bool = true
var xaxis:int = 0

enum {
	FLR_NORMAL = 0,
	FLR_ICE
}

var world_fric = FRICTION
var floor_type = FLR_NORMAL

func _ready():
	FRICTION = ACC
	if Game.god_mode: self.lives = 1

func _physics_process(delta):
	if self.deactivate: return
	if self.death_check(): return
	
	if OS.get_name() != 'Android': self.move(delta)
#	else: self.move_phone(delta)
	if self.deactivate: return
	self._consume(delta)
	if OS.get_name() != 'Android': self.jumping(delta)
#	else: self.jumping_phone(delta)
	self.ducking()
	self.check_anim()
	self.rotating(delta)
	move_and_slide()

var btn_xaxis : int = 0
var btn_yaxis : int = 0

func set_btn_xaxis(val:int) -> void:
	btn_xaxis = val

func set_btn_yaxis(val:int) -> void:
	btn_yaxis = val

func detect_movement() -> int:
	var movement = btn_xaxis
	if btn_xaxis == 0:
		movement = Input.get_axis("move_left", "move_right")
	return movement

func detect_jumping() -> int:
	var movement = btn_yaxis
	if btn_yaxis == 0:
		movement = Input.is_action_pressed("jump")
	if not movement and Input.is_action_pressed("duck"):
		movement = -1
	return movement

func move(_delta) -> bool:
	@warning_ignore("narrowing_conversion")
#	xaxis = detect_movement()
	xaxis = Input.get_axis("move_left", "move_right")
	
	var curr_acc = ACC

	floor_type = FLR_NORMAL
	if worldChecker.get_overlapping_areas().size() > 0:
		for area in worldChecker.get_overlapping_areas():
			if "EndGame" in area.name:
				emit_signal("game_end")
				self.deactivate = true
				return false
			if "ice" in area.name:
				floor_type = FLR_ICE
			if "spike" in area.name:
				_get_hit(spike_damage)
			if "SuperTramp" in area.name:
				play_jump()
				velocity.y = JUMP * 1.25
				set_deferred("is_jumping",false)
				area.activate()
			if "wind" in area.name:
				velocity.x += area.force * self.vs_wind #placeholder
	if floor_type == FLR_NORMAL:
		world_fric = FRICTION / 2.
	elif floor_type == FLR_ICE:
		world_fric = 0
		curr_acc = ACC / 10.
	if not is_on_floor():
		curr_acc = ACC / 2.
		world_fric = FRICTION / 10.
	if xaxis and self.ashes_amount > 0: velocity.x += xaxis * curr_acc
	else: velocity.x = move_toward(velocity.x, 0, world_fric)
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	if velocity.x != 0: return true
	return false
	
func get_which_wall_collided() -> int :
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_normal().x > 0 and xaxis < 0:
			return -1
		elif collision.get_normal().x < 0 and xaxis > 0:
			return 1
	return 0

func jumping(delta) -> void:
	if is_on_wall_only() and xaxis != 0 and velocity.y > 0:
		velocity.y += gravity/10. * delta
		set_deferred("is_jumping", false)
	elif not is_on_floor(): velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") or is_jumping: #and self.ashes_amount > 0: 
		if is_on_floor():
			set_deferred("is_jumping", true)
			play_jump()
		if is_on_wall_only() and not is_jumping:
			play_jump()
			velocity.x = JUMP * get_which_wall_collided() * 3.
			velocity.y = -abs(velocity.x) / 8.
			if velocity.x > 0:
				Input.action_release("move_left")
			if velocity.x < 0:
				Input.action_release("move_right")
		elif is_jumping:
			velocity.y += JUMP/JUMP_FORCE_STEPS
		if abs(velocity.y) > abs(JUMP) - abs(JUMP/JUMP_FORCE_STEPS) or is_on_ceiling():
			set_deferred("is_jumping", false)
		self._consume(delta * 4)
#		self.ashes_amount -= abs(JUMP) * delta
#		consume_ashes.emit(self.ashes_amount)
	if Input.is_action_just_released("jump"): 
		is_jumping = false


func ducking():
	if can_fall and Input.is_action_pressed("duck"):
		collisionShape.set_deferred("scale", Vector2(0.4, 0.4))
	else:
		collisionShape.set_deferred("scale", Vector2(1., 1.))


func _on_floor_checker_body_entered(_body):
	can_fall = false # Replace with function body.
	

func _on_floor_checker_body_exited(_body):
	if is_on_floor():
		can_fall = true # Replace with function body.


# ^-------^ movems ^-------^ #
		

func rotating(delta) -> void:
	if velocity.x != 0:
		self.idle = 0
		var grad:float = velocity.x / 100
		sprite.rotate(deg_to_rad(grad))
		eyes.rotate(deg_to_rad(grad))
	else:
		self.idle += delta
		sprite.rotation = move_toward(sprite.rotation, 0.0, delta * 3)
		eyes.rotation = move_toward(eyes.rotation, 0.0, delta * 3)

func check_anim() -> void:
	if velocity == Vector2(0,0): self.open_eyes()
	else: self.close_eyes()
	if self.idle > 5:
		$AnimationPlayer.play("Idle")
		self.idle = 0

func open_eyes() -> void:
	if not moving: return
	moving = false
	$AnimationPlayer.play("Open_Eyes")

func close_eyes() -> void:
	if moving: return
	moving = true
	$AnimationPlayer.play("Close_Eyes")

func get_more_ash(value:float) -> void:
	self.ashes_amount += value
	if self.ashes_amount > self.ashes_full: self.ashes_amount = self.ashes_full
	consume_ashes.emit(self.ashes_amount)

func play_jump() -> void:
	$JumpSFX.stop()
	$JumpSFX.seek(0.000)
	$JumpSFX.play()

# ---------------------------------------------------------------------------- #
# -- Player HP

signal got_hit
signal death_signal
signal respawn_signal
signal game_over
signal game_end

@export var consume:float = 1
@export var lives:int = 5
@export var inv_time:float = 1.5

var ashes_amount:float = 100.0
var status:String = "active"
var invincible:bool = false
var died:bool = false
@export var deactivate:bool = false

func _consume(dt) -> void:
	if self.ashes_amount > 0: 
		self.ashes_amount -= dt * consume
		consume_ashes.emit(self.ashes_amount)
	else: velocity.x = 0

func _get_hit(damage:float) -> void:
	if not invincible:
		$Sprite2D.material.set_shader_parameter("damaged", !self.invincible)
		ashes_amount -= damage
		if Game.hard_mode or Game.god_mode: ashes_amount = 0
		self.invincible = true
		$Timer.start(self.inv_time)
		got_hit.emit()
		# do a white flash with shaders

func _on_timer_timeout():
	$Sprite2D.material.set_shader_parameter("damaged", !self.invincible)
	self.invincible = false

func death_check() -> bool:
	if self.ashes_amount <= 0 and not self.died:
		self.died = true
		self.lives -= 1
		$Sprite2D.visible = false
		$Eyes.visible = false
		$CollisionShape2D.disabled = true
		$CPUParticles2D.emitting = true
		self.velocity = Vector2.ZERO
		$respawn.start()
		self.invincible = true
		death_signal.emit()
	
	if self.lives <= 0: 
		game_over.emit()
	
	if self.died: return true
	return false

func respawn() -> void:
	self.invincible = true
	$Timer2.start(0.3)
	respawn_signal.emit()
	is_jumping = false
	is_ducking = false
	can_fall = true
	$Sprite2D.rotation_degrees = 0
	$Eyes.rotation_degrees = 0
	ashes_amount = 100.0
	self.died = false
	$Sprite2D.visible = true
	$Eyes.visible = true
	$CollisionShape2D.disabled = false

func _on_timer_2_timeout():
	self.invincible = false

func _game_over():
	game_over.emit()
