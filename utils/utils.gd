class_name Utils extends Object


static func get_combinations(array: Array, choose: int) -> Array:
	var result: Array = []
	_generate_combinations(array, choose, 0, [], result)
	return result


static func _generate_combinations(array: Array, choose: int, start: int, current: Array, result: Array) -> void:
	if current.size() == choose:
		result.append(current.duplicate())
		return
	for i in range(start, array.size()):
		current.append(array[i])
		_generate_combinations(array, choose, i + 1, current, result)
		current.pop_back()
