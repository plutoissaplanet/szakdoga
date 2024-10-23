extends Node

class_name REQUIREMENTS

enum properties {
	minimumNumberOfRooms,
	maximumNumberOfRooms,
	minimumNumberOfEnemies,
	maximumNumberOfEnemies,
	minimumNumberOfGames,
	maximumNumberOfGames
}

enum enemy_properties {
	enemyHealthPoints,
	enemyAttackPoints,
	enemySpeed,
	enemyCooldownTime
}

const difficulty = {
	"easy" : {},
	"medium":{},
	"hard": {}
}

#var difficultySelection: OptionButton
#var meleeSelection: CheckBox
#var rangedSelection: CheckBox
#var healthPointsSelection: SpinBox
#var attackPointsSelection: SpinBox
#var enemySpeedSetter: HSlider
#var enemyAttackSpeedSetter: HSlider
#var enemyCooldownSetter: HSlider

const enemy_difficulty = {
	"easy" : {
		enemy_properties.enemyHealthPoints: Vector2i(10, 40),
		enemy_properties.enemyAttackPoints: Vector2i(1, 10),
		enemy_properties.enemyCooldownTime: Vector2i(15, 20)
	},
	"medium": {
		enemy_properties.enemyHealthPoints: Vector2i(41, 70),
		enemy_properties.enemyAttackPoints: Vector2i(11, 30),
		enemy_properties.enemyCooldownTime: Vector2i(5, 14)
	},
	"hard": {
		enemy_properties.enemyHealthPoints: Vector2i(71, 100),
		enemy_properties.enemyAttackPoints: Vector2i(1, 90),
		enemy_properties.enemyCooldownTime: Vector2i(1, 4)
	}
}

const room_sizes = {
	"small": Vector2i(9,9),
	"medium": Vector2i(11,9),
	"large": Vector2i(16,9),
	"extra large": Vector2i(20,9)
}


