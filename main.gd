extends Node2D

var my_car: RigidBody2D
var tyre_b: RigidBody2D
var tyre_f: RigidBody2D

var status: String = "START"
var dist_board: Label
var big_text: Label
var pop_up_txt: Label

var timer_count: float = 0.0
var highest_dist: int = 0
var target_dist: int = 1000

var f1: float
var f2: float
var a1: float
var a2: float
var prev_x: int = -1050
var track_len: int = 4250

var engine_noise: AudioStreamPlayer
var thud_sound: AudioStreamPlayer
var bgm: AudioStreamPlayer

var songs_list = ["res://music1.ogg", "res://music2.ogg", "res://music3.ogg"]

func _ready():
	randomize() 
	f1 = randf_range(0.002, 0.006)
	f2 = randf_range(0.005, 0.012)
	a1 = randf_range(45, 95) 
	a2 = randf_range(15, 35)

	var screen_ui = CanvasLayer.new()
	
	dist_board = Label.new()
	dist_board.add_theme_font_size_override("font_size", 32)
	dist_board.add_theme_color_override("font_color", Color(1, 1, 1))
	dist_board.position = Vector2(25, 25)
	dist_board.text = "Distance: 0m"
	screen_ui.add_child(dist_board)
	
	pop_up_txt = Label.new()
	pop_up_txt.add_theme_font_size_override("font_size", 48)
	pop_up_txt.add_theme_color_override("font_color", Color(0.9, 0.8, 0.1))
	pop_up_txt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pop_up_txt.size = Vector2(get_viewport_rect().size.x, 100)
	pop_up_txt.position = Vector2(0, 60)
	pop_up_txt.modulate.a = 0 
	screen_ui.add_child(pop_up_txt)
	
	big_text = Label.new()
	big_text.add_theme_font_size_override("font_size", 55)
	big_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	big_text.size = Vector2(get_viewport_rect().size.x, 200)
	big_text.position = Vector2(0, get_viewport_rect().size.y / 2 - 110)
	screen_ui.add_child(big_text)
	
	var intro_screen = Control.new()
	screen_ui.add_child(intro_screen)
	
	var bg_pic = TextureRect.new()
	if ResourceLoader.exists("res://Screenshot 2026-09-19 030958.jpg"):
		bg_pic.texture = load("res://Screenshot 2026-09-19 030958.jpg")
	bg_pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg_pic.size = get_viewport_rect().size
	intro_screen.add_child(bg_pic)
	
	var play_btn = Button.new()
	play_btn.text = "PLAY"
	play_btn.add_theme_font_size_override("font_size", 42)
	play_btn.add_theme_color_override("font_color", Color(1, 1, 1))
	play_btn.size = Vector2(240, 75)
	play_btn.position = Vector2(get_viewport_rect().size.x / 2 - 120, get_viewport_rect().size.y - 140)
	
	var btn_look = StyleBoxFlat.new()
	btn_look.bg_color = Color(0.2, 0.75, 0.22) 
	btn_look.corner_radius_top_left = 35
	btn_look.corner_radius_top_right = 35
	btn_look.corner_radius_bottom_left = 35
	btn_look.corner_radius_bottom_right = 35
	btn_look.border_width_bottom = 5
	btn_look.border_color = Color(0.12, 0.45, 0.15) 
	btn_look.shadow_color = Color(0, 0, 0, 0.5)
	btn_look.shadow_size = 4
	play_btn.add_theme_stylebox_override("normal", btn_look)
	
	var hover_look = btn_look.duplicate()
	hover_look.bg_color = Color(0.28, 0.85, 0.3) 
	play_btn.add_theme_stylebox_override("hover", hover_look)
	
	var pressed_look = btn_look.duplicate()
	pressed_look.bg_color = Color(0.15, 0.55, 0.18) 
	pressed_look.border_width_bottom = 0 
	pressed_look.content_margin_top = 5 
	play_btn.add_theme_stylebox_override("pressed", pressed_look)
	
	play_btn.pressed.connect(self.start_game.bind(intro_screen))
	intro_screen.add_child(play_btn)
	add_child(screen_ui)

	var para_bg = ParallaxBackground.new()
	var p_layer = ParallaxLayer.new()
	var sky_pic = Sprite2D.new()
	
	if ResourceLoader.exists("res://bg.png"):
		var tex = load("res://bg.png")
		sky_pic.texture = tex
		sky_pic.scale = Vector2(4.2, 4.2) 
		sky_pic.position = Vector2(0, -480)
		sky_pic.centered = false
		p_layer.motion_mirroring = Vector2(tex.get_width() * 4.2, 0)
		
	p_layer.motion_scale = Vector2(0.25, 0.25) 
	p_layer.add_child(sky_pic)
	para_bg.add_child(p_layer)
	add_child(para_bg)

	for x in range(5):
		make_road()

	var options = [
		{ 
			"body": "res://separate/girl/Body.png",
			"head": "res://separate/girl/Head.png",
			"wheel1": "res://separate/girl/Wheel (1).png",
			"wheel2": "res://separate/girl/Wheel (2).png",
			"body_scale": Vector2(0.5, 0.5),
			"head_scale": Vector2(0.3, 0.3),
			"wheel_scale": Vector2(0.65, 0.65),
			"head_offset": Vector2(-15, -35),
			"wheel_b_offset": Vector2(-50, 40),
			"wheel_f_offset": Vector2(50, 40)
		},
		{ 
			"body": "res://separate/orc/Body.png",
			"head": "res://separate/orc/Head.png",
			"wheel1": "res://separate/orc/Wheel (1).png",
			"wheel2": "res://separate/orc/Wheel (2).png",
			"body_scale": Vector2(0.5, 0.5),
			"head_scale": Vector2(0.3, 0.3),
			"wheel_scale": Vector2(0.65, 0.65),
			"head_offset": Vector2(-5, -45),
			"wheel_b_offset": Vector2(-45, 50), 
			"wheel_f_offset": Vector2(50, 50)
		},
		{ 
			"body": "res://separate/truck/Body.png",
			"head": "res://separate/truck/Head.png",
			"wheel1": "res://separate/truck/Wheel (1).png",
			"wheel2": "res://separate/truck/Wheel (2).png",
			"body_scale": Vector2(0.5, 0.5),
			"head_scale": Vector2(0.28, 0.28), 
			"wheel_scale": Vector2(0.7, 0.7), 
			"head_offset": Vector2(-15, -60), 
			"wheel_b_offset": Vector2(-55, 60), 
			"wheel_f_offset": Vector2(55, 60)
		}
	]
	
	var selected_car = options.pick_random()

	my_car = RigidBody2D.new()
	my_car.mass = 8.5 
	my_car.position = Vector2(0, -50)
	my_car.z_index = 5 
	
	var hit_box = CollisionShape2D.new()
	hit_box.shape = CapsuleShape2D.new() 
	hit_box.shape.height = 115
	hit_box.shape.radius = 22 
	hit_box.rotation_degrees = 90
	my_car.add_child(hit_box)
	
	var body_img = Sprite2D.new()
	if ResourceLoader.exists(selected_car["body"]):
		body_img.texture = load(selected_car["body"])
		body_img.scale = selected_car["body_scale"]
	my_car.add_child(body_img)

	var head_img = Sprite2D.new()
	if ResourceLoader.exists(selected_car["head"]):
		head_img.texture = load(selected_car["head"])
		head_img.scale = selected_car["head_scale"] 
		head_img.position = selected_car["head_offset"]
	my_car.add_child(head_img)
	
	var camera = Camera2D.new()
	camera.zoom = Vector2(0.72, 0.72)
	camera.position = Vector2(260, -90) 
	my_car.add_child(camera)
	
	add_child(my_car)

	tyre_b = build_tyre(selected_car["wheel_b_offset"], selected_car["wheel1"], selected_car["wheel_scale"])
	tyre_f = build_tyre(selected_car["wheel_f_offset"], selected_car["wheel2"], selected_car["wheel_scale"])

	add_shockers(my_car, tyre_b, selected_car["wheel_b_offset"])
	add_shockers(my_car, tyre_f, selected_car["wheel_f_offset"])

	engine_noise = AudioStreamPlayer.new()
	if ResourceLoader.exists("res://engine.ogg"):
		engine_noise.stream = load("res://engine.ogg")
		engine_noise.volume_db = -2.5 
	add_child(engine_noise)

	thud_sound = AudioStreamPlayer.new()
	if ResourceLoader.exists("res://crash.wav"):
		thud_sound.stream = load("res://crash.wav")
		thud_sound.volume_db = 1.0 
	add_child(thud_sound)

	bgm = AudioStreamPlayer.new()
	bgm.volume_db = -22.0
	bgm.finished.connect(next_song)
	add_child(bgm)

func next_song():
	var rand_song = songs_list.pick_random()
	if ResourceLoader.exists(rand_song):
		bgm.stream = load(rand_song)
		bgm.play()

func make_road():
	var floor_obj = StaticBody2D.new()
	var floor_hit = CollisionPolygon2D.new()
	var floor_color = Polygon2D.new()
	var p = PackedVector2Array()
	
	p.append(Vector2(prev_x, 1600)) 
	var next_x = prev_x + track_len
	
	for x in range(prev_x, next_x + 60, 60):
		var y = 420 + sin(x * f1) * a1 + sin(x * f2) * a2
		p.append(Vector2(x, y))
			
	p.append(Vector2(next_x, 1600)) 
	
	floor_hit.polygon = p
	floor_color.polygon = p
	floor_color.color = Color(0.18, 0.68, 0.22) 
	floor_obj.add_child(floor_hit)
	floor_obj.add_child(floor_color)
	
	var phys = PhysicsMaterial.new()
	phys.friction = 0.95
	floor_obj.physics_material_override = phys
	add_child(floor_obj)
	prev_x = next_x

func start_game(ui_node):
	status = "RUNNING"
	ui_node.queue_free() 
	
	if engine_noise.stream != null:
		engine_noise.play()
	next_song()

func build_tyre(pos: Vector2, img: String, s: Vector2) -> RigidBody2D:
	var t = RigidBody2D.new()
	t.position = pos
	t.mass = 2.2
	t.z_index = 4 
	var mat = PhysicsMaterial.new()
	mat.friction = 1.0 
	t.physics_material_override = mat
	var col = CollisionShape2D.new()
	col.shape = CircleShape2D.new()
	col.shape.radius = 21.5
	var vis = Sprite2D.new()
	if ResourceLoader.exists(img):
		vis.texture = load(img)
		vis.scale = s 
	t.add_child(col)
	t.add_child(vis)
	add_child(t)
	return t

func add_shockers(car_node: Node, t_node: Node, pos: Vector2):
	var j = PinJoint2D.new()
	add_child(j) 
	j.position = pos
	j.node_a = car_node.get_path()
	j.node_b = t_node.get_path()
	j.softness = 0.35 
	j.disable_collision = true

func show_pop(dist_val: int):
	pop_up_txt.text = str(dist_val) + "m CROSSED!"
	var t = get_tree().create_tween()
	t.tween_property(pop_up_txt, "modulate:a", 1.0, 0.4)
	t.tween_interval(2.2)
	t.tween_property(pop_up_txt, "modulate:a", 0.0, 0.6)

func _physics_process(delta):
	if status != "RUNNING":
		return

	timer_count += delta
	var curr_d = max(0, int(my_car.position.x / 52))
	if curr_d > highest_dist:
		highest_dist = curr_d
		dist_board.text = "Distance: " + str(highest_dist) + "m"
		
		if curr_d >= target_dist:
			show_pop(target_dist)
			target_dist += 1000

	if my_car.position.x > prev_x - (track_len * 2):
		make_road()

	if engine_noise.playing:
		var spd = abs(tyre_b.angular_velocity)
		engine_noise.pitch_scale = clamp(1.0 + (spd / 42.5), 1.0, 2.6) 

	if abs(my_car.rotation_degrees) > 105:
		status = "DEAD"
		engine_noise.stop()
		if thud_sound.stream != null:
			thud_sound.play()
		
		var speed_avg = 0.0
		if timer_count > 0:
			speed_avg = highest_dist / timer_count
			
		big_text.add_theme_color_override("font_color", Color(0.9, 0.1, 0.1))
		big_text.text = "WASTED!\nTravelled: %dm\nAvg Speed: %.1f m/s" % [highest_dist, speed_avg]
		
		await get_tree().create_timer(3.2).timeout
		get_tree().reload_current_scene()
		return

	var pwr = 0.0
	if Input.is_action_pressed("ui_right") or Input.is_physical_key_pressed(KEY_D):
		pwr += 1.0
	if Input.is_action_pressed("ui_left") or Input.is_physical_key_pressed(KEY_A):
		pwr -= 1.0
	
	if pwr != 0:
		tyre_b.apply_torque_impulse(pwr * 61500 * delta)
		tyre_f.apply_torque_impulse(pwr * 61500 * delta)
		my_car.apply_torque_impulse(-pwr * 79000 * delta)
