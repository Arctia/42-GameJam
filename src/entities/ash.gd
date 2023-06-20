extends CharacterBody2D

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

@export var ashes_full:float = 100000
#@export var ashes_amount:float = 100000

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity") *1.5
var is_jumping:bool = false : 
	set(value) :
		is_jumping = value
var is_ducking:bool = false
var can_fall:bool = true
var xaxis:int = 0

var world_fric = FRICTION

func _ready():
	FRICTION = ACC

func _physics_process(delta):
	if self.move(delta): self._consume(delta)
	self.jumping(delta)
	self.ducking()
	self.check_anim()
	self.rotating(delta)
	move_and_slide()

func move(_delta) -> bool:
	xaxis = Input.get_axis("move_left", "move_right")
	
	var curr_acc = ACC
	if not is_on_floor():
		curr_acc /= 2.
		world_fric /= 10.
	if xaxis and self.ashes_amount > 0: velocity.x += xaxis * ACC
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
		if is_on_wall_only() and not is_jumping:
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

# ---------------------------------------------------------------------------- #
# -- Player HP

signal got_hit

@export var consume:float = 1
@export var lives:int = 5

var ashes_amount:float = 100.0
var status:String = "active"
var invincible:bool = true

func _consume(dt) -> void:
	if self.ashes_amount > 0: 
		self.ashes_amount -= dt * consume
		consume_ashes.emit(self.ashes_amount)
	else: velocity.x = 0

func _get_hit(damage:float) -> void:
	if not invincible:
		ashes_amount -= damage
		self.invincible = true
		$Timer.start()
		got_hit.emit()
		# do a white flash with shaders

func _on_timer_timeout():
	self.invincible = false
