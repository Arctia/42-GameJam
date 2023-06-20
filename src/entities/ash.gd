extends CharacterBody2D

signal setup_ashes(total_ash, current_ash)
signal consume_ashes(new_value)

const JUMP_FORCE_STEPS : float = 5.

@export var ACC:float = 0
@export var MAX_SPEED:float = 400
@export var JUMP:float = -500
var FRICTION:float
var moving:bool = false
var idle:float = 0.0

@onready var sprite = $Sprite2D
@onready var eyes = $Eyes
@onready var collisionShape = $CollisionShape2D

@export var ashes_full:float = 100000
@export var ashes_amount:float = 100000

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity") *1.5
var is_jumping:bool = true
var is_ducking:bool = false

func _ready():
	FRICTION = ACC

func _physics_process(delta):
	if self.move(delta): self.reduce_ashes(delta)
	self.jumping(delta)
	self.ducking()
	self.check_anim()
	self.rotating(delta)
	move_and_slide()

func move(_delta) -> bool:
	var xaxis = Input.get_axis("move_left", "move_right")
	
	if xaxis and self.ashes_amount > 0: velocity.x += xaxis * ACC
	else: velocity.x = move_toward(velocity.x, 0, FRICTION/2)
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	if velocity.x != 0: return true
	return false


func jumping(delta) -> void:
	if not is_on_floor() and not is_on_wall_only(): velocity.y += gravity * delta
	elif is_jumping and is_on_wall_only():
		if velocity.y < 0:
			velocity.y = 0.
		velocity.y += gravity/10. * delta
	else:
		is_jumping = false
		collisionShape.set_deferred("scale", Vector2(1., 1.))
	
	if is_on_wall_only():
		is_jumping = false
	if Input.is_action_pressed("jump") and not is_jumping and not is_ducking: #and self.ashes_amount > 0: 
		if is_on_wall_only():
			velocity.x += JUMP 
			print(velocity)
		else:
			velocity.y += JUMP/JUMP_FORCE_STEPS
		if abs(velocity.y) > abs(JUMP) - abs(JUMP/JUMP_FORCE_STEPS): is_jumping = true
		if not collisionShape.disabled:
			collisionShape.set_deferred("scale", Vector2(0.5, 0.5))
#		self.ashes_amount -= abs(JUMP) * delta
#		consume_ashes.emit(self.ashes_amount)
	elif Input.is_action_just_released("jump"): is_jumping = true
	if is_jumping:
		collisionShape.set_deferred("scale", Vector2(0.5, 0.5))


func ducking() -> void:
	if Input.is_action_pressed("duck"):
		collisionShape.set_deferred("scale", Vector2(0.5, 0.5))
		is_jumping = true
	else:
		if collisionShape.disabled and not is_jumping:
			collisionShape.set_deferred("scale", Vector2(1., 1.))
	is_ducking = collisionShape.disabled
	

func reduce_ashes(delta) -> void:
	if self.ashes_amount > 0: 
		self.ashes_amount -= abs(velocity.x) * delta
		consume_ashes.emit(self.ashes_amount)
	else: velocity.x = 0

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
		#$AnimationPlayer.play("Idle")
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
