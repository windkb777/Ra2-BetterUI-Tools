extends Window

@onready var node = [$ScreenShot/A/A,$ScreenShot/D/D,$ScreenShot/mask,$content/Rect/Image/picture,$content/Rect/Slide_Bar/detail/label,$content/Rect/Slide_Bar/type,$content/Top_Bar/clip,$content/Rect/Slide_Bar/shp_name]
var pic_size = Vector2.ZERO
var crop_mode = -1

func _ready():
	size = Vector2(pic_size.split("x")[0].to_int()+160,pic_size.split("x")[1].to_int()+40)
	#get_tree().get_root().files_dropped.connect(File_Drop)
	bind_node()

func _input(event):
	$content/Rect/Image.custom_minimum_size = $content.size-Vector2(164,44)
	Crop(crop_mode)
	rename()

##connect node
func bind_node():
	##hide node
	$content/Top_Bar/clip.hide();$ScreenShot.hide()
	##load_pic
	#var pic = load("res://tex/UI_Ref/%s.png"%get_parent().edit_num)
	var pic = $content/Rect/Image/picture.texture
	node[3].texture = pic
	##mouse_enter
	node[0].connect("mouse_entered",func():crop_mode=0)
	node[1].connect("mouse_entered",func():crop_mode=1)
	##button link
	connect("close_requested",queue_free)
	var button = get_tree().get_nodes_in_group("button")
	for i in button:i.connect("pressed",button_link.bind(i));
	button_link($content/Top_Bar/keep_scale);button_link($content/Top_Bar/stretch)
func button_link(nodes):
	match nodes.name:
		"default":
			var img_size = Vector2(pic_size.split("x")[0].to_int(),pic_size.split("x")[1].to_int())
			$content/Rect/Image.custom_minimum_size = img_size
			node[3].stretch_mode = 2
			size = img_size
		"edit":
			if nodes.is_pressed():$content/Top_Bar/clip.show()
			else:$content/Top_Bar/clip.hide();$ScreenShot.hide()
		"clip":
			if node[6].button_pressed:$ScreenShot.show()
			elif !node[6].button_pressed:$ScreenShot.hide()
		"keep_scale":
			if nodes.is_pressed():node[3].stretch_mode = 4
			elif !nodes.is_pressed():node[3].stretch_mode = 2
		"stretch":
			if nodes.is_pressed():node[3].stretch_mode = 0
			elif !nodes.is_pressed():node[3].stretch_mode = 3
		"load_image":LoadFiles()
		"confirm":queue_free()
		"cancel":queue_free()
func rename():
	var tp = node[5].get_item_text(node[5].selected)
	var hz = "0000."
	if !node[7].button_pressed:hz="."
	node[4].text = get_parent().edit + hz + tp
func Crop(num:int):
	var slide = [$ScreenShot/A,$ScreenShot/D,$ScreenShot/quad,$ScreenShot/mask]
	if Input.is_action_pressed("L_Click"):
		size_changed.emit()
		match num:
			0:slide[0].position = get_mouse_position()
			1:slide[1].position = get_mouse_position()
		##quad_line
		slide[2].points[0] = slide[0].position
		slide[2].points[1] = Vector2(slide[1].position.x,slide[0].position.y)
		slide[2].points[2] = slide[1].position
		slide[2].points[3] = Vector2(slide[0].position.x,slide[1].position.y)
		##crop_mask
		slide[3].position = slide[0].position
		slide[3].size = Vector2(slide[1].position.x-slide[0].position.x,slide[1].position.y-slide[0].position.y)
	elif Input.is_action_just_released("L_Click"):
		crop_mode = -1 ##exit crop mode
	#var Zone = $ScreenShot/mask
	#var zp = Zone.get_rect().position
	#var sz = Zone.get_rect().size+Zone.position
	#var mouse = get_mouse_position()
	#var limit = [zp.y-40,sz.y,zp.x,sz.x]
	##假如鼠标在选区范围外 else 在选区范围内
	#if mouse.y < limit[0] or mouse.y > limit[1] or mouse.x < limit[2] or mouse.x > limit[3]:pass
	#else:if Input.is_action_pressed("R_Click"):print($ScreenShot.global_position)

func ImageSaveShot():
	await get_parent().Waitime(0.2)
	await RenderingServer.frame_post_draw
	var file = get_tree().get_first_node_in_group("file_name").text
	var Pic = get_viewport().get_texture().get_image()
	var img_crop = $content/Rect/Image/picture.get_rect()
	var img_resize = Rect2(Vector2(0,42),img_crop.size)
	var render = Pic.get_region(img_resize)
	if node[5].get_item_text(node[5].get_selected_id()) == "jpg":get_parent().images.append(render)
	elif node[5].get_item_text(node[5].get_selected_id()) == "png":get_parent().images.append(render)
	get_parent().file_name.append(file)
	#print(file,img_resize)
	queue_free()

func LoadFiles():
	$FileDialog.show()

func _on_file_dialog_file_selected(path):
	var image = Image.new()
	image.load(path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	##Edit Panel image & icon image
	node[3].texture = image_texture
	#get_parent().edit_num
	var buttons = get_parent().get_node("buttons").get_children()
	buttons[get_parent().edit_num].get_node("pic").texture = image_texture
	

#func File_Drop(files):
	#var Zone = $content/Rect/Image/picture
	#var zp = Zone.get_rect().position
	#var sz = Zone.get_rect().size+Zone.position
	#var mouse = get_mouse_position()
	#var limit = [zp.y-40,sz.y,zp.x,sz.x]
	##假如鼠标在选区范围外 else 在选区范围内
	#if mouse.y < limit[0] or mouse.y > limit[1] or mouse.x < limit[2] or mouse.x > limit[3]:pass
	#else:
		#var image = Image.new()
		#image.load(files[0])
		#var image_texture = ImageTexture.new()
		#image_texture.set_image(image)
		#Zone.texture = image_texture
		#print(image,files)
