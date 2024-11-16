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
	enemyCooldownTime,
	enemyAttackSpeed
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


const roomPositions = {
	1: Vector2i(0,0),
	2: Vector2i(1152, 0),
	3: Vector2i(2304, 0),
	4: Vector2i(3456, 0),
	5: Vector2i(4608, 0),
	6: Vector2i(5760, 0)
}


var enemy_values = {
	"easy": 10,
	"medium": 20,
	"hard": 50
}

var map_values = {
	"easy" : 50,
	"medium": 100,
	"hard": 150
}

var minigame_values = {
	"easy": 10,
	"medium": 20,
	"hard": 50
}

const enemy_difficulty = {
	"easy" : {
		enemy_properties.enemyHealthPoints: Vector2i(10, 40),
		enemy_properties.enemyAttackPoints: Vector2i(10, 20),
		enemy_properties.enemyCooldownTime: Vector2i(50, 100),
		enemy_properties.enemySpeed: Vector2i(20, 50),
		enemy_properties.enemyAttackSpeed: Vector2i(70, 100)
	},
	"medium": {
		enemy_properties.enemyHealthPoints: Vector2i(41, 70),
		enemy_properties.enemyAttackPoints: Vector2i(20, 30),
		enemy_properties.enemyCooldownTime: Vector2i(20, 50),
		enemy_properties.enemySpeed: Vector2i(50, 70),
		enemy_properties.enemyAttackSpeed: Vector2i(50, 70)
	},
	"hard": {
		enemy_properties.enemyHealthPoints: Vector2i(71, 100),
		enemy_properties.enemyAttackPoints: Vector2i(30, 50),
		enemy_properties.enemyCooldownTime: Vector2i(10, 20),
		enemy_properties.enemySpeed: Vector2i(70, 100),
		enemy_properties.enemyAttackSpeed: Vector2i(20, 50)
	}
}

const room_sizes = {
	"small": Vector2i(9,9),
	"medium": Vector2i(11,9),
	"large": Vector2i(16,9),
	"extra large": Vector2i(20,9)
}

const number_of_rooms_based_on_difficulty = {
	"easy": {
		"min":2,
		"max":3
	},
	"medium": {
		"min":2,
		"max":4
	},
	"hard": {
		"min":4,
		"max":6
	}
}

const number_of_enemies_to_place = {
	"easy":{
		"single": {
			"easy": {
				"min": 2,
				"max": 5
			},
			"medium": {
				"min": 1,
				"max": 2
			},
			"hard": {
				"min": 0,
				"max": 0
			}
		},
		"multiple":{
			"easy": {
				"min": 1,
				"max": 3
			},
			"medium": {
				"min": 0,
				"max": 1
			},
			"hard": {
				"min": 0,
				"max": 0
			}
		}
	},
	"medium": {
		"single": {
			"easy": {
				"min": 5,
				"max": 10
			},
			"medium": {
				"min": 5,
				"max": 8
			},
			"hard": {
				"min": 1,
				"max": 1
			}
		},
		"multiple":{
			"easy": {
				"min": 2,
				"max": 5
			},
			"medium": {
				"min": 3,
				"max": 6
			},
			"hard": {
				"min": 0,
				"max": 0
			}
		}
	},
	"hard": {
		"single": {
			"easy": {
				"min": 5,
				"max": 15
			},
			"medium": {
				"min": 5,
				"max": 10
			},
			"hard": {
				"min": 5,
				"max": 10
			}
		},
		"multiple":{
			"easy": {
				"min": 5,
				"max": 7
			},
			"medium": {
				"min": 3,
				"max": 4
			},
			"hard": {
				"min": 3,
				"max": 4
			}
		}
	}
}

const number_of_minigames_to_place = {
	"easy": {
		"easy": {
			"min":2,
			"max":3
		},
		"medium": {
			"min": 1,
			"max": 2
		},
		"hard": {
			"min":0,
			"max":0
		}
	},
	"medium": {
		"easy": {
			"min":2,
			"max":3
		},
		"medium": {
			"min": 2,
			"max": 3
		},
		"hard": {
			"min":0,
			"max":1
		}
	},
	"hard": {
		"easy": {
			"min":4,
			"max":6
		},
		"medium": {
			"min": 4,
			"max": 6
		},
		"hard": {
			"min":3,
			"max":6
		}
	}
}


const from_door_positions_in_rooms = {
	"small": Vector2i(96, 186),
	"medium": Vector2i(128, 186),
	"large": Vector2i(160, 186),
	"extra large": Vector2i(224, 186)
}

const to_door_positions_in_rooms = {
	"small": Vector2i(192, 186),
	"medium": Vector2i(224, 186),
	"large": Vector2i(352, 186),
	"extra large": Vector2i(416, 186)
}

const number_of_items_based_on_difficutly = {
	"easy": 5,
	"medium": 10,
	"hard": 15
}



