extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D
@onready var coyote_time = $"../Coyote_Time"
var wasLeft = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if (velocity.y < 0):
			sprite_2d.animation = "jumping"
		if (velocity.y > 0):
			sprite_2d.animation = "falling"

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_time.is_stopped()):
		velocity.y = JUMP_VELOCITY

	var was_on_floor = is_on_floor()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 25)
		
	
	var isLeft = velocity.x < 0
	if (velocity.x < 0):
		wasLeft = true
	if (velocity.x > 1):
		wasLeft = false
	sprite_2d.flip_h = wasLeft

	move_and_slide()
	
	if (was_on_floor && !is_on_floor()):
		coyote_time.start()
	
	
