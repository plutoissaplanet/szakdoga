extends Node

@onready var loginButton = $CanvasLayer/Login
@onready var signupButton = $CanvasLayer/SignUp
@onready var backButton = $CanvasLayer/Back
@onready var label = $CanvasLayer/Label
@onready var usernameInput = $CanvasLayer/Username
var databaseConfig= DB.new()
var DB_PATHS = databaseConfig.DB_PATHS
var userDoc: FirestoreDocument
var auth

func _ready():
	add_parallax()
	Firebase.Auth.login_succeeded.connect(login_succeeded)
	Firebase.Auth.login_failed.connect(login_succeeded)
	Firebase.Auth.signup_succeeded.connect(signup_succeeded)
	Firebase.Auth.signup_failed.connect(signup_succeeded)

func add_parallax():
	var parallax = PARALLAX.new()
	add_child(parallax)

	
func _on_login_pressed():
	var email = $CanvasLayer/Email.text
	var password = $CanvasLayer/Password.text
	
	if email.length() !=0 && password.length() !=0:
		if label.text=='Log in':
			Firebase.Auth.login_with_email_and_password(email, password)
		else:
			Firebase.Auth.signup_with_email_and_password(email, password)

func _set_user_in_users_collection(username: String, userID: String):
	var response = await _is_username_already_in_use(username)
	if not response:
		await Firebase.Firestore.collection(DB_PATHS.USERS).add(userID, {
			'username': username,
			'signUpTime': Time.get_date_dict_from_system(),
			'character': ''
		})
		await Firebase.Firestore.collection(DB_PATHS.USED_USERNAMES).add(username, {'userID': userID})
	else:
		print("username taken")
	
func _is_username_already_in_use(username: String):
	var data = await Firebase.Firestore.collection('usedUsernames').get_doc(username)
	if data:
		return true
	return false
	

func _on_sign_up_pressed():
	label.text='Sign up'
	loginButton.position.y += 70
	backButton.position.y += 70
	signupButton.visible = false
	backButton.visible=true
	usernameInput.visible=true
	loginButton.text = 'Sign up'
func _on_back_button_pressed():
	backButton.visible=false
	signupButton.visible=true
	usernameInput.visible=false
	loginButton.text = 'Log in'
	label.text = "Log in"
	loginButton.position.y -= 70
	backButton.position.y -= 70 

func login_succeeded(auth):
	userDoc = await Firebase.Firestore.collection('users').get_doc(auth['localid'])
	if userDoc:
		if not userDoc.document.get('characterSet')['booleanValue']:
			get_tree().change_scene_to_file("res://MainMenuThings/CharCreator.tscn")
		else:
			get_tree().change_scene_to_file("res://main.tscn")

func login_failed(error, message):
	print(error)
	print(message)
	
func signup_succeeded(auth):
	#print(auth)
	_set_user_in_users_collection(usernameInput.text, auth['localid'])

func signup_failed(error, message):
	print(error)
	print(message)
