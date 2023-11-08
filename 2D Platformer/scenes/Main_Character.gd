extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D
@onready var coyote_time = $"../Coyote_Time"
var wasLeft = false
@onready var jump_sound = $AudioStreamPlayer2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var being_hit = false

func die():
	pass

func _physics_process(delta):
	# Add the gravity.
	if (velocity.x > 1 || velocity.x < -1) && being_hit == false:
		sprite_2d.animation = "running"
	elif being_hit == false:
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
		jump_sound.play()

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
	
	


func _on_area_2d_body_entered(body):
	if body.name == "Enemy" && being_hit == false:
		being_hit = true
		sprite_2d.play("hit")
		await sprite_2d.animation_finished
		being_hit = false


func _on_sprite_2d_animation_finished():
	pass # Replace with function body.
