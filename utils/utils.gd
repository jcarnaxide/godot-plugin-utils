class_name Utils extends Object


static func get_viewport_scale_factor(viewport: Viewport) -> Vector2:
	# Get viewport size in pixels.
	var viewport_size: Vector2 = viewport.get_visible_rect().size
	# Get window size and stretch settings.
	var window_size: Vector2 = DisplayServer.window_get_size()
	return (viewport_size / window_size)


static func get_safe_area_scaled(viewport: Viewport) -> Rect2:
	# Safe area only implemented for mobile platforms, so override otherwise
	if OS.get_name() != "Android" and OS.get_name() != "iOS":
		return Rect2(Vector2.ZERO, viewport.get_visible_rect().size)

	# Get safe area in screen pixels.
	var safe_area: Rect2 = DisplayServer.get_display_safe_area()
	var scale_factor = get_viewport_scale_factor(viewport)

	# Convert safe area to scene space
	var safe_area_position = safe_area.position * scale_factor
	var safe_area_size = safe_area.size * scale_factor
	return Rect2(safe_area_position, safe_area_size)


static func generate_points_around_ellipse(
	center: Vector2,
	radius: Vector2,
	num_points: int,
	angle_offset: float = 0.0
) -> Array[Vector2]:
	var answer: Array[Vector2] = []
	for i in range(num_points):
		var angle = angle_offset + (i * TAU / num_points)
		answer.append(Vector2(center.x + radius.x * cos(angle), center.y + radius.y * sin(angle)))
	return answer


static func pick_other_item(item: Variant, item_list: Array[Variant]) -> Variant:
	var count = len(item_list)
	if count <= 1:
		return item

	var curr_index = item_list.find(item)
	var next_index = randi() % count-1
	if next_index >= curr_index:
		next_index += 1
	return item_list[next_index]


static func coin_flip() -> bool:
	return randi() % 2 == 1


static func random_negative() -> float:
	if coin_flip():
		return -1
	return 1


static func random_chance(ratio: float) -> bool:
	return randi() % 100 <= ratio


static func generate_non_overlapping_positions(viewport: Viewport, count: int, min_distance: float) -> Array[Vector2]:
	var safe_area := get_safe_area_scaled(viewport)
	var positions: Array[Vector2] = []
	var attempts := 0
	var max_attempts := count * 20
	while positions.size() < count and attempts < max_attempts:
		var x = randf_range(safe_area.position.x + min_distance, safe_area.position.x + safe_area.size.x - min_distance)
		var y = randf_range(safe_area.position.y + min_distance, safe_area.position.y + safe_area.size.y - min_distance)
		var candidate = Vector2(x, y)
		var valid = true
		for pos in positions:
			if pos.distance_to(candidate) < min_distance:
				valid = false
				break
		if valid:
			positions.append(candidate)
		attempts += 1
	if positions.size() < count:
		printerr(
			"Failed to generate spawn positions in a reasonable number of attempts. " +
			"Generated: %s, Requested: %s, Max Attempts: %s" % [positions.size(), count, max_attempts]
		)
	return positions


static func shuffle_array_deterministic(array: Array, rng: RandomNumberGenerator) -> Array:
	var shuffled = array.duplicate()
	for i in range(shuffled.size() - 1, 0, -1):
		var j = rng.randi_range(0, i)
		var temp = shuffled[i]
		shuffled[i] = shuffled[j]
		shuffled[j] = temp
	return shuffled


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
