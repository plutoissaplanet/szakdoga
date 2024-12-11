extends Node


	
func deduct_points(points: int):
	UserData.totalPoints = UserData.totalPoints - points
	var content = {
		"points": UserData.totalPoints
	}
	
	var stringifiedContent = JSON.stringify(content)
	JSON_FILE_FUNCTIONS.save_json_file(UserData.userFolderPath+"points.json", stringifiedContent)
	upload_to_database(UserData.totalPoints)
	
	
func add_points(points: int):
	UserData.totalPoints = UserData.totalPoints + points
	var content = {
		"points": UserData.totalPoints
	}
	
	var stringifiedContent = JSON.stringify(content)
	JSON_FILE_FUNCTIONS.save_json_file(UserData.userFolderPath+"points.json", stringifiedContent)
	upload_to_database(UserData.totalPoints)


func load_points_from_database():
	var query: FirestoreQuery = FirestoreQuery.new()
	query.from("leaderboard")

	
	var result = await Firebase.Firestore.query(query)
	
	print(result)
	
	return result
	
func upload_to_database(points: int):
	var leaderboardCollection: FirestoreCollection = Firebase.Firestore.collection("leaderboard")
	UserData.totalPoints = points
	var userData = await Firebase.Firestore.collection('leaderboard').get_doc(UserData.username)
	
	if not userData:
		await leaderboardCollection.add(UserData.username, {'points': points})
	else:
		var document: FirestoreDocument = await leaderboardCollection.get_doc(UserData.username)
		document.add_or_update_field('points', points)
		await leaderboardCollection.update(document)
	

