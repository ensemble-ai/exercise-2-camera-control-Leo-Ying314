class_name TargetFocus
extends CameraControllerBase


@export var lead_speed: float = target.BASE_SPEED + 50
@export var catchup_delay_duration: float = 0.5
@export var catchup_speed: float = target.BASE_SPEED * 0.85
@export var leash_distance: float = 5

var idle_timer: float = 0.0

func _ready() -> void:
	super()
	position = target.position
	idle_timer = 0.0


func _process(delta: float) -> void:
	if !current:
		global_position = target.global_position
		return

	if draw_camera_logic:
		draw_logic()
	
	# dynamic lead speed is utilized to maintain camera positioning in hyper-speed
	var ratio = target.velocity.length() / target.BASE_SPEED
	var dynamic_lead_speed = lead_speed * ratio
	
	var target_vec = Vector2(target.global_position.x, target.global_position.z)
	var camera_vec = Vector2(global_position.x, global_position.z)
	var distance_to_target = camera_vec.distance_to(target_vec)
	
	var direction_to_target = Vector2(target.velocity.x, target.velocity.z).normalized()
	
	if target.velocity.length() > 0:
		idle_timer = 0.0
		
		var desired_position = target_vec + direction_to_target * leash_distance
		var new_position = camera_vec
		
		if distance_to_target > leash_distance + 1:
			# prevents camera from moving too far from target in hyper speed
			var max_move_distance = dynamic_lead_speed * delta
			var move_vec = (desired_position - camera_vec)
			if move_vec.length() > max_move_distance:
				move_vec = move_vec.normalized() * max_move_distance
			new_position += move_vec
		else:
			new_position.x += direction_to_target.x * dynamic_lead_speed * delta
			new_position.y += direction_to_target.y * dynamic_lead_speed * delta
		
		# ensures target is never more than leash distance away from camera 
		# after new_position calculation
		if new_position.distance_to(target_vec) > leash_distance:
			var to_target = (target_vec - new_position).normalized()
			new_position = target_vec - to_target * leash_distance
			
		global_position.x = new_position.x
		global_position.z = new_position.y
	else:
		idle_timer += delta
		if idle_timer >= catchup_delay_duration:
			global_position = global_position.move_toward(target.global_position, catchup_speed * delta)
	
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
