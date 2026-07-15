extends KinematicBody2D


export var speed = 500
export var acceleration = 0.05
var velocity = Vector2.ZERO
export var jumpPower = 420
export var gravity = 7
onready var cooldownTimer = $DashCooldownTimer
var jumping = false
var coyote = true
var coyoteTime = 0 # tracks amount of time the player hasnt been grounded
var stompPower = 2000
var canMove = true
var dashCooldown = false


func _physics_process(delta):
	# gravity
	velocity.y += gravity
	
	if not is_on_floor() and not jumping:
		coyoteTime += delta
	
	# coyote time
	
	
	if coyoteTime < 0.2:
		coyote = true
	else:
		coyote = false
		
	
	if is_on_floor():
		jumping = false
		coyoteTime = 0
		velocity.y = 0
	
	# jumping
	if not jumping:
		if Input.is_key_pressed(KEY_SPACE) and is_on_floor() or Input.is_key_pressed(KEY_SPACE) and coyote:
			velocity.y -= jumpPower
			coyote = false
			jumping = true
			

		
			
	# stomp
	if not is_on_floor() and Input.is_action_just_pressed("stomp"):
		velocity.x = 0
		velocity.y += stompPower
		canMove = false

		
	if is_on_floor() and velocity.x == 0:
		canMove = true
		
	# dash
	if Input.is_action_just_pressed("air_dash") and not dashCooldown:
		velocity.y = 0
		velocity.x *= 3.5
		dashCooldown = true
		cooldownTimer.start()
	
	
	# movement
	if canMove:
		if Input.is_action_pressed("ui_left"):
			velocity.x = lerp(velocity.x,-speed,acceleration)
			
		elif Input.is_action_pressed("ui_right"):
			velocity.x = lerp(velocity.x,speed,acceleration)
		else:
			velocity.x = lerp(velocity.x,0,acceleration)
		
	move_and_slide(velocity,Vector2.UP)





func _on_DashCooldownTimer_timeout():
	dashCooldown = false
