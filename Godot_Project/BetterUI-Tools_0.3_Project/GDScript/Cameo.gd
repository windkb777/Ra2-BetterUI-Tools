@tool
extends Panel

@export var cameo = "YYPHQ"
@export_enum("X1","X2","X3","X4") var zoom = "X1"
@export var title_on_top = false
@export var hide_line = false
@export var line_color : Color = Color.LAWN_GREEN
@export_range(0,1) var title_bg_opcity
@export_category("image")
@export var image : Texture2D
@export var background : Texture2D
@export var font_colors = GradientTexture2D.new()

func _process(_delta):
	Set_Cameo()

func Set_Cameo():
	var labels = [$gray/Margin/label_con/text,$gray/Margin/label_con/shadow]
	var gradient = $gray/Margin/label_con/text/gradient
	var con = $gray/Margin/label_con
	var dir = ["left","top","right","bottom"]
	if hide_line:for i in dir.size():get_theme_stylebox("panel")["border_width_%s"%dir[i]] = 0
	;get_theme_stylebox("panel")["expand_margin_%s"%dir[i]] = 0
	else:for i in dir.size():get_theme_stylebox("panel")["border_width_%s"%dir[i]] = 1
	;get_theme_stylebox("panel")["expand_margin_%s"%dir[i]] = 1
	font_colors.gradient = gradient.get_theme_stylebox("panel")["texture"].gradient
	$gray.get_theme_stylebox("panel")["bg_color"].a = 1 - title_bg_opcity
	get_theme_stylebox("panel")["border_color"] = line_color
	$bg.texture = background
	$pic.texture = image
	con.custom_minimum_size = gradient.size - Vector2(0,5)
	for i in labels:i.text = self.cameo
	font_colors.width = 6;font_colors.height = 1
	self.scale = zoom.split("X")[1].to_int() * Vector2(1,1)
	if !title_on_top:$gray.z_index = 5
	else:$gray.z_index = 4
