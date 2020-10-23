extends KinematicBody2D

var motion = Vector2.ZERO
var acceleration = 3000
var speed = 500



func _physics_process(delta):
	var input_vector = get_input_vector()
	
	if input_vector == Vector2.ZERO:
		apply_friction(acceleration * delta)
	else:
		calc_movement(input_vector * acceleration * delta)
		
	look_rotation()
	
	motion = move_and_slide(motion)


func get_input_vector():
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	return input_vector.normalized()

func apply_friction(friction):
	if motion.length() > friction:
		motion -= motion.normalized() * friction
	else:
		motion = Vector2.ZERO

func calc_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(speed)
	

func look_rotation():
	
	var look_vector = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vector.y, look_vector.x)
