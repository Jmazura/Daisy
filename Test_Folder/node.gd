extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_ROTATE_SPEED = 1.5

@onready var anim:AnimationPlayer = get_node("CollisionShape3D/Catwalk Walk Forward 03/AnimationPlayer")
@onready var cam:Camera3D = get_node("Camera3D")

func _physics_process(delta: float) -> void:
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Rotate camera with left/right input (A/D or arrow keys)
	var camera_input := Input.get_action_strength("left") - Input.get_action_strength("left")
	if camera_input != 0:
		cam.rotate_y(camera_input * delta * CAMERA_ROTATE_SPEED)

	# Get movement input relative to camera direction
	var input_dir := Input.get_vector("right", "left", "down", "up")
	if input_dir != Vector2.ZERO:
		# Get the camera's facing direction (flat on XZ plane)
		var cam_basis := cam.global_transform.basis
		var forward := -cam_basis.z.normalized()
		var right := cam_basis.x.normalized()

		# Convert 2D input into 3D movement vector relative to camera
		var move_dir := (right * input_dir.x + forward * input_dir.y).normalized()

		# Apply movement
		velocity.x = move_dir.x * SPEED
		velocity.z = move_dir.z * SPEED

		# Play animation
		anim.play("mixamo_com")
	else:
		# Smoothly stop when no input
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

		# Stop animation if no movement
		if velocity.length() < 0.1:
			anim.stop()

	# Apply gravity and move
	move_and_slide()
