extends Area2D

signal hit
export var speed = 400
var screen_size
var side = load("res://assests/art/korosensei_side.png")
var up = load("res://assests/art/korosensei_up.png")
var koro = load("res://assests/art/korosensei.png")

func _ready():
	screen_size = get_viewport_rect().size
	$Sprite.texture = koro
	hide()

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	
	if velocity.x != 0:
		$Sprite.texture = side
		$Sprite.flip_v = false
		$Sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$Sprite.texture = up
	else:
		$Sprite.texture = koro


func _on_Korosensei_body_entered(_body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
