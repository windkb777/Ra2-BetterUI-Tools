@tool
extends Panel

##UI_Slot
const UI_named = ["启动视频(bik)","游戏载入封面图","主画面雷达视频(bik)","主画面-背景","任务界面-背景","遭遇战界面-背景","遭遇战自定义-背景","网际网络-背景","退出游戏对话框-背景","游戏结束提示"]
const ui_shp_name = ["ea_wwlogo","glslmd","ra2ts_l","mnscrnl","fsbkgbld","mnscrnlcoopgamesetup","mnscrnlcustomizebattle","mutiplayselection","pudlgbgn","grfxtxt"]
const ui_pal_name  = ["ea_wwlogo","glsmd","ra2ts_l","shell","fsbkgbld","mnscrnlcoopgamesetup","mnscrnlcustomizebattle","mutiplayselection","dialogn","grfxtxt"]
const sizes = ["800x600","800x600","632x570","632x568","632x570","632x578","632x568","454x328","800x520","436x448"]

##Country_Slot
const Country_name = ["美国","法国","德国","韩国","英国","苏俄","古巴","尤里","伊拉克","利比亚"]
const C_shp_name = ["ls800ustates","ls800france","ls800germany","ls800korea","ls800ukingdom","ls800russia","ls800cuba","ls800yuri","ls800iraq","ls800libya"]
const C_pal_name = ["mplsu","mplsf","mplsg","mplsk","mplsuk","mplsr","mplsc","smpyls","mplsi","mplsl"]

@onready var render_button = get_tree().get_nodes_in_group("render")

var UI_Switch = [0,0,0,0,0,0,0,0,0,0]
var output_path = "E:/"

var edit : String
var edit_num : int
var colored = Color(200,0,20,255)
var images = []
var tab : int

func _ready():
	Tabss(0)
	$Top_Bar/select_folder.connect("pressed",func():$FileDialog.show())
	$Top_Bar/Render/output.connect("pressed",OneKey_Output_All)
	##set_output_file_name
	for i in render_button.size():render_button[i].name = $UI.get_child(i).get_node("HBox/panel_3/label").text

func _input(event):
	var a = $Top_Bar/Render/def.get_children()
	var b = $Top_Bar/Render/new.get_children()
	const black = Color(0.05,0.05,0.05,255)
	for i in a.size():
		match UI_Switch[i]:
			0:a[i].color = black
			1:a[i].color = colored;b[i].color = black;render_button[i].disabled = false
			2:b[i].color = colored;a[i].color = black;render_button[i].disabled = false

##Setting
func Tabss(tab:int):
	UI_Switch = [0,0,0,0,0,0,0,0,0,0]
	var nodes = $UI.get_children()
	for i in nodes.size():
		const colors = [Color(0.88,0.233,0.211,1),Color(0,0.278,0.801,1),Color(0.757,0.161,0,1),Color.SLATE_BLUE]
		var node_name = nodes[i].get_node("HBox/panel_1/label")
		var node_size = nodes[i].get_node("HBox/panel_2/label")
		var node_shp = nodes[i].get_node("HBox/panel_3/label")
		var node_pal = nodes[i].get_node("HBox/panel_4/label")
		var node =  $buttons.get_child(i)
		if tab == 0:
			node_name.text = UI_named[i]
			node_size.text = sizes[i]
			node_shp.text = ui_shp_name[i]
			node_pal.text = ui_pal_name[i]
			nodes[i].get_node("1").position.x = 0;;nodes[i].get_node("2").position.x = 92
			node.get_child(0).set_texture(load("res://tex/UI_Ref/%s.png"%i))
			node.get_child(1).set_texture(load("res://tex/UI_Ref/new.png"))
			## Sort Hide ReColor
			if node_shp.text != node_pal.text:
				node_shp.get_parent().custom_minimum_size.x=84;node_shp.get_parent().get_theme_stylebox("panel")["bg_color"] = colors[0]
				node_pal.get_parent().custom_minimum_size.x=84;node_pal.get_parent().get_theme_stylebox("panel")["bg_color"] = colors[1]
			else:node_pal.get_parent().hide();node_shp.get_parent().custom_minimum_size.x=180
			if node_shp.get_parent().custom_minimum_size.x == 180:node_shp.get_parent().get_theme_stylebox("panel")["bg_color"] = colors[3]
			node_name.get_parent().custom_minimum_size.x = 180
		elif tab == 1:
			node_name.text = Country_name[i]
			node_size.text = "800x600"
			node_shp.text = C_shp_name[i]
			node_pal.text = C_pal_name[i]
			## Restore Color
			node_pal.get_parent().show()
			node_shp.get_parent().get_theme_stylebox("panel")["bg_color"] = colors[0]
			##
			node_name.get_parent().custom_minimum_size.x = 108
			node_shp.get_parent().custom_minimum_size.x = 140
			node_pal.get_parent().custom_minimum_size.x = 100
			#nodes[i].get_node("1").position.x = 0;nodes[i].get_node("2").position.x = 91
			node.get_child(0).set_texture(load("res://tex/UI_Ref/a%s.png"%i))
			node.get_child(1).set_texture(load("res://tex/UI_Ref/new.png"))

func _on_file_dialog_dir_selected(dir):
	output_path = dir

func OneKey_Output_All():
	for i in render_button:
		match i.disabled:
			false:i.emit_signal("pressed")
