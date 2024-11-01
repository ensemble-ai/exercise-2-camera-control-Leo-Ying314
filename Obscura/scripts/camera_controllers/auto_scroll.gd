class_name AutoScroll
extends CameraControllerBase

@export var box_width: float = 10.0
@export var box_height: float = 10.0
@export var autoscroll_speed: Vector3 = Vector3(5, 0, 0)
@export var top_left: Vector2
@export var bottom_right: Vector2

func _ready() -> void:
	super()
	position = target.position


func _process(delta: float) -> void:
	if !current:
		global_position = target.global_position
		return
		
	if draw_camera_logic:
		draw_logic()
		
	top_left = Vector2(
		global_position.x - box_width, 
		global_position.z - box_height / 2.0
	)
	
	bottom_right = Vector2(
		global_position.x + box_width,
		global_position.z + box_height / 2.0
	)
	
	# moves camera position based on autoscroll_speed vector
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta # = 0
	
	var tpos = target.global_position
	var cpos = global_position
	
	# logic to keep target within bounds
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - top_left.x
	if diff_between_left_edges < 0:
		target.global_position.x -= diff_between_left_edges
		
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - bottom_right.x
	if diff_between_right_edges > 0:
		target.global_position.x = bottom_right.x - target.WIDTH / 2.0
	
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - top_left.y
	if diff_between_top_edges < 0:
		target.global_position.z = top_left.y + target.HEIGHT / 2.0
		
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - bottom_right.y
	if diff_between_bottom_edges > 0:
		target.global_position.z = bottom_right.y - target.HEIGHT / 2.0
	
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
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
