class_name PositionLock
extends CameraControllerBase


func _ready() -> void:
	super()
	position = target.position
	
	
func _process(delta: float) -> void:
	if !current:
		global_position = target.global_position
		return
	
	if draw_camera_logic:
		draw_logic()
	
	# keeps camera position locked on target
	global_position = target.global_position
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	var half_cross: float = 2.5  # Half of the 5x5 unit cross size

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	immediate_mesh.surface_add_vertex(Vector3(-half_cross, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(half_cross, 0, 0))

	immediate_mesh.surface_add_vertex(Vector3(0, 0, -half_cross))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, half_cross))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
