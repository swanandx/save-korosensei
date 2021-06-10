extends Node

export (PackedScene) var Bullet
var score
var high_score = load_saved()

func _ready():
	randomize()
	$HUD/ScoreLabel.text = "Highscore\n" + str(high_score)

func game_over():
	$ScoreTimer.stop()
	$BulletTimer.stop()
	$DeathSound.play()
	$Music.stop()
	$HUD.show_game_over()
	get_tree().call_group("bullets", "queue_free")
	if score > int(high_score):
		save(str(score))
		$HUD/ScoreLabel.text = "New Highscore!\n" + str(score)

func new_game():
	score = 0
	$Korosensei.start($StartPos.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Let's begin")
	$Music.play()


func _on_BulletTimer_timeout():
	$BulletPath/BulletSpawnLocation.offset = randi()
	var bullet = Bullet.instance()
	add_child(bullet)
	var direction = $BulletPath/BulletSpawnLocation.rotation + PI / 2
	bullet.position = $BulletPath/BulletSpawnLocation.position
	direction += rand_range(-PI / 4 , PI / 4)
	bullet.rotation = direction
	bullet.linear_velocity = Vector2(rand_range(bullet.min_speed, bullet.max_speed), 0)
	bullet.linear_velocity = bullet.linear_velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$BulletTimer.start()
	$ScoreTimer.start()

func save(content):
	var file = File.new()
	file.open("user://save_game.dat", File.WRITE)
	file.store_string(content)
	file.close()

func load_saved():
	var file = File.new()
	if file.file_exists("user://save_game.dat"):
		file.open("user://save_game.dat", File.READ)
		var content = file.get_as_text()
		file.close()
		return content
	else:
		return 0
