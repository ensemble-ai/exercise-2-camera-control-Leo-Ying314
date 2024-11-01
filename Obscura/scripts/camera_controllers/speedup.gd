class_name Speedup
extends CameraControllerBase


@export var box_width:float = 10.0
@export var box_height:float = 10.0
@export var push_ratio:float = 0.15
@export var pushbox_top_left: Vector2
@export var pushbox_bottom_right: Vector2
@export var speedup_zone_top_left: Vector2
@export var speedup_zone_bottom_right: Vector2

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		global_position = target.global_position
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	pushbox_top_left = Vector2(
		global_position.x - box_width,
		global_position.z - box_height / 2
	)
	pushbox_bottom_right = Vector2(
		global_position.x + box_width,
		global_position.z + box_height / 2
	)
	speedup_zone_top_left = Vector2(
		global_position.x - box_width * 0.6,
		global_position.z - box_height * 0.6 / 2.0
	)
	speedup_zone_bottom_right = Vector2(
		global_position.x + box_width * 0.6,
		global_position.z + box_height * 0.6 / 2.0
	)
	
	#boundary checks
	#left
	var target_left = tpos.x - target.WIDTH / 2.0
	var diff_between_left_edges = target_left - pushbox_top_left.x
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	elif target_left < speedup_zone_top_left.x:
		if target.velocity.x < 0:
			global_position.x += (target_left - speedup_zone_top_left.x) * push_ratio
	
	#right
	var target_right = tpos.x + target.WIDTH / 2.0
	var diff_between_right_edges = target_right - pushbox_bottom_right.x
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	elif target_right > speedup_zone_bottom_right.x:
		if target.velocity.x > 0:
			global_position.x += (target_right - speedup_zone_bottom_right.x) * push_ratio
	
	#top
	var target_top = tpos.z - target.HEIGHT / 2.0
	var diff_between_top_edges = target_top - pushbox_top_left.y
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	elif target_top < speedup_zone_top_left.y:
		if target.velocity.z < 0:
			global_position.z += (target_top - speedup_zone_top_left.y) * push_ratio
	
	#bottom
	var target_bottom = tpos.z + target.HEIGHT / 2.0
	var diff_between_bottom_edges = target_bottom - pushbox_bottom_right.y
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
	elif target_bottom > speedup_zone_bottom_right.y:
		if target.velocity.z > 0:
			global_position.z += (target_bottom - speedup_zone_bottom_right.y) * push_ratio
			
	super(delta)
	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -box_width
	var right:float = box_width
	var top:float = -box_height / 2
	var bottom:float = box_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	_draw_rect(immediate_mesh, left, right, top, bottom)
	immediate_mesh.surface_end()
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	_draw_rect(immediate_mesh, left * 0.6, right * 0.6, top * 0.6, bottom * 0.6)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()

func _draw_rect(immediate_mesh: ImmediateMesh, left: float, right: float, top: float, bottom: float) -> void:
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
