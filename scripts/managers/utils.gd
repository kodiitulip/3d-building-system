class_name Utils
## An assortment of helper functions

## Casts a ray from [code]screen_point[/code], to intersect with
## [code]plane[/code] returning the [code]Vector3[/code] of the position or [code]null[/code]
static func cast_ray_to_plane(plane: Plane, screen_point: Vector2, camera: Camera3D, ray_length: float) -> Vector3:
	var origin: Vector3 = camera.project_ray_origin(screen_point)
	var end: Vector3 = origin + camera.project_ray_normal(screen_point) * ray_length
	if plane.intersects_segment(origin, end) is Vector3:
		return plane.intersects_segment(origin, end)
	return Vector3.ZERO
