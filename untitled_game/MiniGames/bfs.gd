extends Node

var fourDirections = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]
var eightDirections = [
		Vector2i(0, 1), Vector2i(0, -1),  
		Vector2i(1, 0), Vector2i(-1, 0),  
		Vector2i(1, 1), Vector2i(1, -1),  
		Vector2i(-1, 1), Vector2i(-1, -1) 
	]
var directionsDictionary = {
	'up': Vector2i(0, -1),
	'right': Vector2i(1, 0),
	'down': Vector2i(0, 1),
	'left': Vector2i(-1, 0)
}

func bfs(startPoint: Vector2i, finishPoint: Vector2i, matrix, size: Vector2i, objectPos = null):
	var queue = [startPoint]
	
	var visited = []
	for y in range(0, size.y):
		var innerArray = []
		innerArray.resize(size.x)
		innerArray.fill(false)
		visited.append(innerArray)
	
	visited[startPoint.x][startPoint.y] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		
		if current == finishPoint:
			return true
		
		for direction in fourDirections:
			var neighbor = current + direction
			if is_in_bounds(neighbor, size) and !visited[neighbor.x][neighbor.y] and (matrix[neighbor.x][neighbor.y] == 0 or matrix[neighbor.x][neighbor.y] == 3):
				queue.append(neighbor)
				visited[neighbor.x][neighbor.y] = true
				
	return false
	
func dfs_for_finish_position(currentCell: Vector2i, finishCell: Vector2i, mazeMatrix, size: Vector2i):
	mazeMatrix[currentCell.x * 2 + 1][currentCell.y * 2 + 1] = 0
	var directions = fourDirections.duplicate(true)
	directions.shuffle()
	
	if currentCell == finishCell:
		return true
	
	for direction in directions:
		var neighbor = currentCell + direction
		if is_in_bounds(neighbor, size) and mazeMatrix[neighbor.x * 2 + 1][neighbor.y * 2 + 1] == 1:
			var wall = currentCell * 2 + direction + Vector2i(1, 1)
			mazeMatrix[wall.x][wall.y] = 0
			if dfs_for_finish_position(neighbor, finishCell, mazeMatrix, size):
				return true
	return false

func dfs_without_finish(currentCell: Vector2i, mazeMatrix, size: Vector2i):
	mazeMatrix[currentCell.x*2 +1][currentCell.y * 2 + 1] = 0
	var directions = fourDirections.duplicate(true)
	directions.shuffle()
	
	for direction in directions:
		var neighbor = currentCell + direction
		
		if is_in_bounds(neighbor, size) and mazeMatrix[neighbor.x * 2 + 1][neighbor.y * 2 + 1] == 1:
			var wall = currentCell * 2 + direction + Vector2i(1, 1)
			mazeMatrix[wall.x][wall.y] = 0
			dfs_without_finish(neighbor, mazeMatrix, size)

func generate_maze(mazeMatrix, startCell: Vector2i, finishCell: Vector2i, size):
	dfs_for_finish_position(startCell, finishCell, mazeMatrix, size)
	dfs_without_finish(startCell, mazeMatrix, size)
	
	return mazeMatrix

func is_in_bounds(pos: Vector2i, size: Vector2) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < size.y and pos.y < size.x
