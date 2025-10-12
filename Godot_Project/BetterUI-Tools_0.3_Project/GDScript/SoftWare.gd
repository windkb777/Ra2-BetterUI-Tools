extends Node

const sound = ["res://addons/sfx/sel_1.wav","res://addons/sfx/sel_2.wav"]
const unselect_icon = 0.265
var detail = null
var select_button = null

func _ready():
	Buttons_Link()

##Buttons
func Buttons_Link():
	var buttons = get_tree().get_nodes_in_group("Buttons")
	var title = get_tree().get_first_node_in_group("title_label")
	var scene = get_parent().get_child(1)
	detail = get_tree().get_first_node_in_group("detail_label")
	match scene.name:
		"Create_Panel":title.text = "请选择你要创建的单位类型"
		"Modifer":title.text = "新建单位，编辑属性数值!"
	scene.close_requested.connect(get_tree().quit)
	detail.visible_ratio = 0
	for i in buttons:
		i.connect("mouse_entered",Buttons.bind(i,"In"))
		i.connect("mouse_exited",Buttons.bind(i,"Out"))
		i.connect("gui_input",Buttons.bind(InputEvent))
		if scene.name == "Create_Panel":i.modulate.v = unselect_icon
func Buttons(node,state):
	match state:
		"In":
			play_sfx(sound[0])
			select_button = node
			if select_button as PanelContainer:
				select_button.modulate.v = 1.0
			for i in 50:
				detail.visible_ratio += 0.02
				await get_tree().create_timer(0.02).timeout
		"Out":
			detail.visible_ratio = 0
			if select_button != null and select_button is PanelContainer:
				select_button.modulate.v = unselect_icon
	if select_button!=null:
		const space = "   "
		match select_button.name:
			"Unit":detail.text = space+"创建人物角色，使用基本模板进行创建。"
			"Animal":detail.text = space+"新建小动物，纯天然野生无公害单位。"
			"Tank":detail.text = space+"制造新型坦克载具，定制权在你的手里。"
			"Plane":detail.text = space+"制造飞行器，盘旋、冲刺、滑翔、投弹!"
			"Ship":detail.text = space+"开始搭建龙骨骨架，为底盘添上新引擎驱动"
			"Building":detail.text = space+"制作新建筑，建筑施工方面还得看XXX"
			"DEF":detail.text = space+"建立新型防御装置，类似哨戒炮/光棱塔"
			"Machine":detail.text = space+"新功能开发中..."
			"SuperWeapon":detail.text = space+"超级武器建设中..."
			"FX":detail.text = space+"创建新特效,为你的单位增添新特效!!"
		if select_button is not PanelContainer:detail.text = select_button.editor_description
		if Input.is_action_just_pressed("L_Click"):
			var button = select_button
			play_sfx(sound[1])
			match button.name:
				"Unit":
					var panel = load("res://panels/2.Modifer.tscn")
					get_parent().add_child(panel.instantiate(),true)
					#get_parent().get_child(1).queue_free()
					select_button = null
					#panel.show()
			#print(button.name)

func play_sfx(path):
	var sfx = AudioStreamPlayer.new()
	sfx.connect("finished",sfx.queue_free)
	add_child(sfx)
	sfx.stream = load(path)
	sfx.play()
