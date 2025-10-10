extends Node

const 主界面UI = {
"启动视频"="ea_wwlogo/800x600","载入界面"="glslmd/800x600","雷达视频"="ra2ts_l/632x570","背景"="mnscrnl/632x568",
"遭遇战"="mnscrnlcoopgamesetup/632x568","自订战役"="mnscrnlcustomizebattle/632x568","网络"="mutiplayselection",
"战役"="fsbkgbld/632x570","结算A"="mpsscrnl/632x568","结算B"="mpascrnl/632x568","退出A"="pudlgbgn/424x328","结算条"="grfxtxt/436x448/4"}
const 按钮菜单条 = {
"主菜单底部条"="lwscrnl/632x32","载入仪表盘"="sdwrntmp/1008x177/6","仪表盘动态"="sdwrnanm/92x53/91","遭遇战仪表盘"="sdtp/336x199/2",
"菜单按钮背景"="sdbtnbkgd/168x42","底部按钮背景"="sdbtm/168x65","菜单按钮"="sdbtnanm/156x42/17"}
const Nums = [1,2,3,4,5,6,7,8,9,"X","L","R","Z"]

var Select_Pic = null
var Select_Shp : String
var Select_Pal : String
var sub_window = null
var select_button = null

func _ready():
	get_parent().get_child(1).show()
	Buttons_Link()

##Windows Contral
func DragWindows(event,obj):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#obj = get_tree().get_root()
		obj = get_node("/root").get_child(1)
		obj.position += Vector2i(event.relative)
func NewWindow(tscn):
	if sub_window == null:
		var scene = load(tscn).instantiate()
		get_parent().add_child(scene)
		scene.show()
		#var state = tscn.split("/")[3].split(".")[0]
		#match state:#"Yuri":Mode = state+"UI界面编辑器"
	else:
		print("已经打开了UI界面编辑器")

##File Loads
func OpenFile(type):
	##打开文件
	var file_loader = get_tree().get_nodes_in_group("file_loader")
	for i in 3:
		file_loader[i].filters[0] = type
	match type:
		"*.jpg":file_loader[0].show()
		"*.shp":file_loader[1].show()
		"*.pal":file_loader[2].show()
func Shp_Loader(path=""):
	Select_Shp = path
	##加载读取文件
	var loader = FileAccess.get_file_as_bytes(Select_Shp)
	##读文件的十六进程HEX数据
	var hex = loader.hex_encode()
	var hex_size = hex.length()
	##将HEX分组/分别为2字节一组，8字节一组，16字节一组
	var group2 = []
	var group8 = []
	var group18 = []
	for i in range(0,hex_size,2):var byte2 = hex.substr(i,2);group2.append(byte2)
	for i in range(0,group2.size(),8):var byte8 = group2.slice(i,i+8);group8.append(byte8)
	for i in range(0,hex_size,18):var byte18 = hex.substr(i,18);group18.append(byte18)
	##读取文件头数据
	var Empty = (group8[0][0]+group8[0][1]).hex_to_int()
	var FullWidth = (group8[0][0]+group8[0][2]).hex_to_int()
	var FullHeight = (group8[0][0]+group8[0][4]).hex_to_int()
	var NrOfFrames = (group8[0][7]+group8[0][6]).hex_to_int()
	var _Head = [Empty,FullWidth,FullHeight,NrOfFrames]
	#print(_Head)
	####读取动画帧数据
	for i in range(0,NrOfFrames*3,3):
		####跳过文件头部数据 从第一帧开始
		var num = i+1
		####读取帧画面的Offset_XY和像素宽高
		var FrameX = (group8[i][0]+group8[num][0]).hex_to_int()
		var FrameY = (group8[i][0]+group8[num][2]).hex_to_int()
		var FrameWidth = (group8[i][0]+group8[num][4]).hex_to_int()
		var FrameHeight = (group8[i][0]+group8[num][6]).hex_to_int()
		var _FrameSize = {"num"=num/3+1,"offset"=Vector2(FrameX,FrameY),"size"=Vector2(FrameWidth,FrameHeight)}
		#if i==0:print(_FrameSize)
		####0x08/UINT32LE/Flags  ##0x0C/BYTE[4]/FrameColor  ##0x10/UINT32LE/Reserved  ##0x14/UINT32LE/DataOffset
		var Flags = (group8[num][0]+group2[num+8])#.to_utf32_buffer().decode_u32(1)
		var FrameColor = (group8[num][0]+group2[num+12])#.hex_to_int())
		var Reserved = (group8[num][0]+group2[num+16])#.to_utf32_buffer()
		var DataOffset = (group8[num][0]+group2[num+20])#.to_utf32_buffer().decode_u8(254/num)
		var _Spec = [Flags,FrameColor,Reserved,DataOffset]
		print(_Spec)
		####颜色预读
		#var rgb = (Color(snapped((int(FrameColor[0])/15.0),0.001),snapped((int(FrameColor[1])/15.0),0.001),snapped((int(FrameColor[2])/15.0),0.001))).to_html()
		#print_rich("[color="+str(rgb)+"]■■■■■■[/color]")
		####读取到帧数边界停止/动画帧为帧总数÷2/拿GI举例744帧只用到了371帧(从第0帧开始计算)
		if num/3+1 == NrOfFrames/2:return
		####打印输出

func Pal_Loader(path=""):
	##加载读取文件
	Select_Pal = path
	var pals = get_tree().get_first_node_in_group("pal_group").get_children()
	var loader = FileAccess.get_file_as_bytes(Select_Pal)
	var pal :Array
	##读取颜色,768/3=256,63x4=252
	for i in range(0,loader.size(),3):
		var pal_array : Array
		pal_array.append(loader.slice(i,i+3))
		var color = Color.from_rgba8(pal_array[0][0]*4,pal_array[0][1]*4,pal_array[0][2]*4)
		pal.append(color)
	##赋予色盘颜色
	for i in pals.size():pals[i].color = pal[i]
	print("加载色盘文件")
	##赋予图片256颜色
	var er56 = get_tree().get_first_node_in_group("256")
	for i in 256:
		er56.material["shader_parameter/color_%s"%str(i)] = pals[i].color
func Pic_Loader(path=""):
	##加载读取文件
	var image_texture = ImageTexture.new()
	var image = Image.new()
	image.load(path)
	image_texture.set_image(image)
	Select_Pic = image_texture
	get_tree().get_first_node_in_group("image").get_theme_stylebox("normal")["texture"] = Select_Pic
	print("加载图片")
##Button Link
func Buttons_Link():
	var file_loader = get_tree().get_nodes_in_group("file_loader")
	var group = get_tree().get_nodes_in_group("Buttons")
	for i in group:
		i.connect("mouse_entered",Buttons.bind(i," In"))
		i.connect("mouse_exited",Buttons.bind(i,"Out"))
		i.connect("gui_input",Buttons.bind(InputEvent))
		if i.name == "Title":i.connect("gui_input",Global.DragWindows.bind(InputEvent))
	file_loader[0].connect("file_selected",Pic_Loader)
	file_loader[1].connect("file_selected",Shp_Loader)
	file_loader[2].connect("file_selected",Pal_Loader)
func Buttons(node,State):
	#var sfx = $SFX
	match State:
		" In":
			if node.material != null:
				node.material["shader_parameter/shift_color"] = Color(1,1,1,1)
				node.material["shader_parameter/gray"] = 0
			select_button = node;#sfx.play()
		"Out":
			if node.material != null:
				node.material["shader_parameter/shift_color"] = Color(0.4,0.4,0.4,1)
				node.material["shader_parameter/gray"] = 1
	if Input.is_action_just_pressed("L_Click") and select_button!=null and select_button.name!="Title":
		match select_button.name:
			"HUD":NewWindow(Global.Yuri_UI_Editer)
			"load_pal":OpenFile("*.pal")
			"load_shp":OpenFile("*.shp")
			"load_pic":OpenFile("*.jpg")
			"Close":queue_free()
		#print(select_button.name," 按下鼠标左键")
		select_button = null

#func ReadItems():
	#var item = [$VBox/UI_Bar/Page, $VBox/UI_Bar/GameUI, $"VBox/UI_Bar/阵营", $"VBox/UI_Bar/国家", $"VBox/UI_Bar/元素"]
	#for i in item.size():
		#var menus = item[i].get_item_count()
		#for n in menus:
			#var texts = item[i].get_item_text(n)
			#print(texts)
