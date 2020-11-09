extends Node2D


export var size = 30


var pos = 0

var food

var steps = 0.0 

var blocks = []
var blocks_nbr = 0 

var head = Vector2()
var dir = "R"

func change_dir(d):
	dir = d

func _ready():
	blocks.append(Vector2(0,0))
	steps = float(360) / float(size) 
	steps = stepify(steps,0.01)
	random_food()


func random_food():
	randomize()
	var x = stepify(rand_range(0,size-1),1)*steps
	var y = stepify(rand_range(0,size-1),1)*steps
	while(blocks.has(Vector2(x,y))):
		randomize()
		x = stepify(rand_range(0,size-1),1)*steps
		y = stepify(rand_range(0,size-1),1)*steps

	food = Vector2(x,y)

func _input(event):
	if(Input.is_action_just_pressed("ui_down") and dir != "U"):
		change_dir("D")
	if(Input.is_action_just_pressed("ui_up") and dir != "D"):
		change_dir("U")
	if(Input.is_action_just_pressed("ui_left") and dir != "R"):
		change_dir("L")
	if(Input.is_action_just_pressed("ui_right") and dir != "L"):
		change_dir("R")


func _draw():
	#Grid frawing 
	var step = 0
	for i in range(size+1) :
		draw_line(Vector2(step,0),Vector2(step,360),Color(255,255,255))
		draw_line(Vector2(0,step),Vector2(360,step),Color(255,255,255))
		step += 360/size

	#draw food
	draw_rect(Rect2(food,Vector2(360/size,360/size)),Color(1,0,0),true,2)
	#draw the head
	draw_rect(Rect2(head,Vector2(360/size,360/size)),Color(0,0,0),true,2)
	#draw the body
	for i in range(blocks.size()):
		draw_rect(Rect2(blocks[i],Vector2(360/size,360/size)),Color(0,0,0),false,4)


func _on_Timer_timeout():
	match dir :
		"U" : head.y -= steps
		"D" : head.y += steps
		"R" : head.x += steps
		"L" : head.x -= steps

	if(blocks.has(head)):
		print("game_over")

	if(head == food):
		blocks.append(head)
		blocks_nbr += 1
		random_food()

	if(pos < blocks_nbr):
		pos += 1 
		blocks[pos] = head
	else :
		pos = 0
		blocks[pos] = head

	update()
