extends Button

func _ready():
	self.connect("pressed",Output)
	var slots = owner.UI_Switch[owner.name.substr(4).to_int()]
	match slots:
		0:disabled = true

func Output():
	var sel_UI = owner.UI_Switch
	var dir = owner.output_path
	const green = Color(0,200,20,255)
	var number = get_parent().get_index()
	var slots = owner.get_node("UI").get_children()
	var pic_buttons = owner.get_node("buttons").get_children()
	var sized = slots[number].get_node("HBox/panel_2/label").text.split("x")
	
	
	##设置导出图片类型- UI / Battle
	var render_ = ""
	var render = ""
	var pic = null
	if owner.tab == 0:
		render_ = "res://tex/UI_Ref/"
		render = dir+"/%s.png"%pic_buttons[number].get_child(2).name
	elif owner.tab == 1:
		owner.Tabs(1)
		render_ = "res://tex/UI_Ref/a"
		
		#render = dir+"/a%s.png"%owner.get_node("UI").get_children()[get_index()].get_node("HBox/panel_3/label").text
		var nnn = owner.get_node("UI").get_node("HBox/panel_3/label").text
		print(nnn)
	
	for i in sel_UI.size():
		if owner.tab == 0:
			match sel_UI[i]:
				1:pic = load(render_+"%s.png"%number).get_image();owner.colored = green
				2:pic = pic_buttons[number].get_child(1).texture.get_image();owner.colored = green

	pic.resize(sized[0].to_int(),sized[1].to_int())
	pic.save_png(render)
	#print(render)
