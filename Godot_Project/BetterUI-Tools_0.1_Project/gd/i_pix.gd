extends TextureRect

@onready var main = owner

func _ready():
	connect("gui_input",Active)

func Active(event):
	if event is InputEventMouseButton and Input.is_action_just_pressed("L_Click"):
		var UI = owner.get_node("UI").get_children()
		var index = get_parent().get_index()
		var anmi = [UI[index].get_child(3),UI[index].get_child(4)]
		var number = get_parent().get_index()
		
		if name == "ref":
			anmi[0].play("sel_1")
			anmi[1].play("RESET")
			main.UI_Switch[number] = 1
		elif name == "pic":
			anmi[1].play("sel_2")
			anmi[0].play("RESET")
			main.UI_Switch[number] = 2
			edit_image(number)
		#print(number,index)

func edit_image(number): 
	if get_tree().get_node_count_in_group("img_panel") == 0:
		## add panel only one
		var slot = owner.get_node("UI").get_children()[0]
		var sc = load("res://slot/image_panel.tscn").instantiate()
		var sized = slot.get_node("HBox/panel_2/label")
		var shp_text = slot.get_node("HBox/panel_3/label")
		main.edit = shp_text.text
		main.edit_num = number
		sc.pic_size = sized.text
		sc.show()
		await get_tree().create_timer(0.2).timeout
		main.add_child(sc,true)
