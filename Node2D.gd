extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var startSizeX = 256
var startSizeY = 256
var grid = [[]] # 0 means no life and 1 means life
var run_sim = false 
var generation = 0
func create_rand_game_map():
	for x in startSizeX:
		grid.insert(x, [])
		for y in startSizeY:
			var ran_value = rand_range(-1, 100)
			if ran_value < 0:
				grid[x].insert(y, 1)
				$TileMap.set_cell(x,y,1)
			else:
				grid[x].insert(y, 1)
				$TileMap.set_cell(x,y,0)
				
func create_game_premade_map(grid_map):
	grid = grid_map
# Called when the node enters the scene tree for the first time.
func _ready():
	create_blank_grid()
	var button = $MarginContainer/VBoxContainer/Button
	var back_button = $MarginContainer/VBoxContainer2/Back_button
	$MarginContainer/VBoxContainer2.hide()
	back_button.connect("pressed", self, "_back_pressed")
	button.connect("pressed", self, "_button_pressed")

func _back_pressed():
	run_sim = false
	get_tree().change_scene("res://main_menu.tscn")
	queue_free()	
	
func create_blank_grid():
	for x in startSizeX:
		grid.insert(x, [])
		for y in startSizeY:
			grid[x].insert(y, 0)
			$TileMap.set_cell(x,y, 0)
			
			
func _button_pressed():
	if grid != [[]]: 
		create_game_premade_map(grid)
	else: 
		create_rand_game_map()
	print("Game started")
	$MarginContainer/VBoxContainer.hide()
	$MarginContainer/VBoxContainer2.show()
	run_sim = true
	
func check_neighbor(x,y): 
	if (x > 0 and x < startSizeX) and (y > 0 and y < startSizeY):
		return grid[x][y]
	else: 
		return 0
		
func check_state(x,y):
	var curr = grid[x][y]
	var life_state = 0
	life_state += (check_neighbor(x + 1,y) + check_neighbor(x - 1,y) + check_neighbor(x,y + 1) + check_neighbor(x,y - 1) + check_neighbor(x + 1,y + 1) + check_neighbor(x - 1,y - 1) + check_neighbor(x - 1,y + 1) + check_neighbor(x + 1,y - 1))
	if curr == 1 and life_state < 2: 
		grid[x][y] = 0
	elif curr == 1 and life_state >= 3:
		grid[x][y] = 0
	elif curr == 0 and life_state >= 3:
		grid[x][y] = 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func runtime():
	$MarginContainer/VBoxContainer2/HBoxContainer/Generation.text = str(generation)
	for x in startSizeX:
		for y in startSizeY:
			if grid[x][y] == 0:
				$TileMap.set_cell(x,y, 0)
			else:
				$TileMap.set_cell(x,y, 1)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				print("Left button was clicked at ", event.position)
				var y: int = event.position.y/32
				var x: int = event.position.x/32
				if (x > 0 and y > 0): 
					grid[x][y] = 1
					$TileMap.set_cell(x,y, 1)
					
				
			else:
				print("Left button was released")
		if event.button_index == BUTTON_RIGHT: 
			if event.pressed:
				var y: int = event.position.y/32
				var x: int = event.position.x/32
				if (x > 0 and y > 0): 
					grid[x][y] = 0
					$TileMap.set_cell(x,y, 0)
				
func _process(delta):
	if run_sim:
		for x in startSizeX:
			for y in startSizeY:
				check_state(x,y)
		generation = generation + 1
		runtime()
