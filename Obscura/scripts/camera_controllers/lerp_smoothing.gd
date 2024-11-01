class_name LerpSmoothing
extends CameraControllerBase

@export var follow_speed: float = target.BASE_SPEED * 0.25
@export var catchup_speed: float = target.BASE_SPEED * 0.85
@export var leash_distance: float = 5


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		global_position = target.global_position
		return
	
	if draw_camera_logic:
		draw_logic()
	
	# Define 2d vectors since we won't be moving in the y-plane
	var target_vec = Vector2(target.global_position.x, target.global_position.z)
	var camera_vec = Vector2(global_position.x, global_position.z)
	var distance_to_target = camera_vec.distance_to(target_vec)
	
	var direction_to_target = (Vector2(target.global_position.x, target.global_position.z) - Vector2(global_position.x, global_position.z)).normalized()
	var speed = follow_speed
	var dead_zone = 0.2
	
	if distance_to_target >= leash_distance + dead_zone: # add dead zone value to prevent distance calculation bugs
		global_position.x = target.global_position.x - direction_to_target.x * leash_distance
		global_position.z = target.global_position.z - direction_to_target.y * leash_distance
	else:
		if target.velocity.length() == 0:
			speed = catchup_speed
		else:
			speed = follow_speed
		global_position = global_position.move_toward(target.global_position, speed * delta)
		
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
