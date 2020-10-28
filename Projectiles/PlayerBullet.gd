extends "res://Projectiles/Bullet.gd"

const bullethit = preload("res://Effects/BulletHitEffect.tscn")


func _on_Hitbox_body_entered(body):
	Global.instance_scene_on_main(bullethit, position, rotation - (deg2rad(180)))
	queue_free()
