extends KinematicBody2D

#Constants
const PlayerBullet = preload("res://Projectiles/PlayerBullet.tscn")
const muzzleFlash = preload("res://Effects/MuzzleFlashEffect.tscn")

#Weapon Sprites
var pistolSprite = preload("res://Player/Art/survivor1_gun.png")
var machinegunSprite = preload("res://Player/Art/survivor1_machine.png")

#Weapon Related Variables
onready var muzzle = $Muzzle
onready var fireRate = $fireRate
export(float) var pistol_fire_rate = .3
export(float) var machinegun_fire_rate =.09
var current_weapon = 1

#Player Sprite
onready var playerSprite = $Sprite

#Player Movement Variables
export(int) var acceleration = 4000
export(int) var speed = 500
export(int) var bullet_speed = 1500
var motion = Vector2.ZERO


func _ready():
	fireRate.set_wait_time(pistol_fire_rate)

func _physics_process(delta):
	var input_vector = get_input_vector()
	
	if input_vector == Vector2.ZERO:
		apply_friction(acceleration * delta)
	else:
		calc_movement(input_vector * acceleration * delta)
		
	look_rotation()
	change_weapon()
	
	if Input.is_action_pressed("fire") && fireRate.time_left == 0:
		fire_bullet()
	
	motion = move_and_slide(motion)




func get_input_vector():
	#Input vector is keyboard input
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	return input_vector.normalized()

func apply_friction(friction):
	#Friction is friction. This alters the snappiness of the movement
	if motion.length() > friction:
		motion -= motion.normalized() * friction
	else:
		motion = Vector2.ZERO

func calc_movement(acceleration):
	#Acceleration is how quickly we can reach top-speed
	motion += acceleration
	motion = motion.clamped(speed)

func look_rotation():
	#Gets the rotation based on mouse position
	var look_vector = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vector.y, look_vector.x)


func fire_bullet():
	#Instances muzzleflash
	Global.instance_scene_on_main(muzzleFlash, muzzle.global_position, muzzle.global_rotation)
	#Instances playerbullet scene
	var bullet = Global.instance_scene_on_main(PlayerBullet, muzzle.global_position, muzzle.global_rotation)
	bullet.velocity = Vector2.RIGHT.rotated(self.rotation) * bullet_speed
	#Restarts fireRate timer
	fireRate.start()
	#Recoil
	motion -= bullet.velocity * .15

func change_weapon():
	#Weapon changes based on keyboard input
	if Input.is_action_just_pressed("pistol_select"):
		current_weapon = 1
		playerSprite.set_texture(pistolSprite)
		fireRate.set_wait_time(pistol_fire_rate)
	elif Input.is_action_just_pressed("machinegun_select"):
		current_weapon = 2
		playerSprite.set_texture(machinegunSprite)
		fireRate.set_wait_time(machinegun_fire_rate)
