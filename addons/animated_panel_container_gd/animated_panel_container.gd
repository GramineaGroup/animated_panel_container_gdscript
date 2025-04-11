@tool
class_name AnimatedPanelContainer
extends PanelContainer

@export var DefaultTrans: Tween.TransitionType
@export var DefaultEase: Tween.EaseType
var _trans: Tween.TransitionType
var _ease: Tween.EaseType
var _current_minimum_size: Vector2
var _modulate: Color
var _tween: Tween
var _is_hide_called: bool = false
var _current_duration: float = 0
var _delay: float = 0
var _classname: String = "AnimatedPanelContainer"

func create_new_tween() -> AnimatedPanelContainer:
	if _tween != null && _tween.is_running():
		# end the Tween animation immediately, by setting delta longer than the whole duration of the Tween animation
		_tween.custom_step(_current_duration + 1);
	_tween = create_tween().set_parallel(false).set_ease(DefaultEase).set_trans(DefaultTrans)
	_tween.finished.connect(_on_tween_finished)
	return self

func _on_tween_finished() -> void:
	_tween = null
	_ease = DefaultEase
	_trans = DefaultTrans

func _check_tween() -> void:
	if _tween == null:
		printerr("Tween is not set. Call create_new_tween first.")

# should be called before any Animated methods
func set_delay(delay: float) -> AnimatedPanelContainer:
	_delay = delay
	return self

# should be called before any Animated methods
func set_trans(trans: Tween.TransitionType) -> AnimatedPanelContainer:
	_trans = trans
	return self

# should be called before any Animated methods
func set_ease(ease: Tween.EaseType) -> AnimatedPanelContainer:
	_ease = ease
	return self

func animated_hide(duration: float) -> AnimatedPanelContainer:
	animated_transparent_hide(duration)
	animated_collapse(duration)
	return self

func animated_show(duration: float) -> AnimatedPanelContainer:
	animated_expand(duration)
	animated_transparent_show(duration)
	return self

# GDScript cannot override hide() :(
func Hide() -> AnimatedPanelContainer:
	transparent_hide()
	collapse()
	return self

func Show() -> AnimatedPanelContainer:
	expand()
	transparent_show()
	return self

func transparent_hide() -> AnimatedPanelContainer:
	if modulate.a == 0:
		return self
	_is_hide_called = true
	_modulate = modulate
	_internal_transparent_hide(Color(modulate.r, modulate.g, modulate.b, 0))
	return self

func animated_transparent_hide(duration: float) -> AnimatedPanelContainer:
	# why do you want to hide again
	if modulate.a == 0:
		return self
	_check_tween()
	_is_hide_called = true
	_modulate = modulate
	var t = _tween.tween_method(_internal_transparent_hide, modulate, Color(modulate.r, modulate.g, modulate.b, 0), duration).set_ease(_ease).set_trans(_trans)
	if (_delay > 0):
		t.set_delay(duration)
		_delay = 0
	if _current_duration != 0:
		_current_duration += duration
	return self

func _internal_transparent_hide(target: Color) -> void:
	_internal_transparent_show_hide(target)
	if modulate.a == 0:
		_toggle_child_visibility(false)

func transparent_show() -> AnimatedPanelContainer:
	var modulate = self.modulate
	if _is_hide_called:
		# no need to show again
		if modulate.a == _modulate.a:
			return self
		# previously set to 0
		modulate = _modulate
	else:
		self.modulate = Color(self.modulate.r, self.modulate.g, self.modulate.b, 0)
	_internal_transparent_show(modulate)
	return self

func animated_transparent_show(duration: float) -> AnimatedPanelContainer:
	_check_tween()
	# init state, so we make modulate.a = 0
	# and transition back to original a value
	var modulate = self.modulate
	if _is_hide_called:
		# no need to show again
		if modulate.a == _modulate.a:
			return self
		modulate = _modulate
	else:
		self.modulate = Color(self.modulate.r, self.modulate.g, self.modulate.b, 0)
	var t = _tween.tween_method(_internal_transparent_show, self.modulate, modulate, duration).set_ease(_ease).set_trans(_trans)
	if (_delay > 0):
		t.set_delay(duration)
		_delay = 0
	# duartion is not set => this is the first call has duration
	if _current_duration != 0:
		_current_duration += duration
	return self

func _internal_transparent_show(target: Color) -> void:
	if modulate.a == 0:
		_toggle_child_visibility(true)
		visible = true
	_internal_transparent_show_hide(target)

func _internal_transparent_show_hide(target: Color) -> void:
	modulate = target;

func collapse(new_size: Vector2 = Vector2()) -> AnimatedPanelContainer:
	custom_minimum_size = size
	_current_minimum_size = new_size
	_internal_expand_collapse(_current_minimum_size)
	return self

func animated_collapse(duration: float, new_size: Vector2 = Vector2()) -> AnimatedPanelContainer:
	_check_tween()
	_current_minimum_size = new_size
	var t = _tween.tween_method(_internal_expand_collapse, size, new_size, duration).set_ease(_ease).set_trans(_trans)
	if (_delay > 0):
		t.set_delay(duration)
		_delay = 0
	if _current_duration != 0:
		_current_duration += duration
	return self

func expand(new_size: Vector2 = Vector2()) -> AnimatedPanelContainer:
	if new_size.is_equal_approx(Vector2.ZERO):
		# assuming nobody wants to do this in this func
		_update_custom_minimum_size()
		if not visible:
			_toggle_child_visibility(false)
			visible = true
	else:
		_current_minimum_size = new_size
	_internal_expand_collapse(_current_minimum_size)
	return self

func animated_expand(duration: float, new_size: Vector2 = Vector2()) -> AnimatedPanelContainer:
	_check_tween()
	if new_size.is_equal_approx(Vector2.ZERO):
		# assuming nobody wants to do this in this func
		_update_custom_minimum_size()
		if not visible:
			_toggle_child_visibility(false)
			visible = true
	else:
		_current_minimum_size = new_size
	var t = _tween.tween_method(_internal_expand_collapse, size, _current_minimum_size, duration).set_ease(_ease).set_trans(_trans)
	if (_delay > 0):
		t.set_delay(duration)
		_delay = 0
	custom_minimum_size = _current_minimum_size
	if _current_duration != 0:
		_current_duration += duration
	return self

func _update_custom_minimum_size() -> void:
	_current_minimum_size = _get_child_combined_minimum_size()

func _internal_expand_collapse(target: Vector2) -> void:
	custom_minimum_size = target

func animated_scale(scale: Vector2, duration: float) -> AnimatedPanelContainer:
	_check_tween()
	_current_minimum_size = size * scale
	var t = _tween.tween_method(_internal_scale, self.scale, scale, duration).set_ease(_ease).set_trans(_trans)
	custom_minimum_size = _current_minimum_size
	if _current_duration != 0:
		_current_duration += duration;
	return self

func _internal_scale(target: Vector2) -> void:
	scale = target

func _toggle_child_visibility(visible: bool) -> void:
	for child in get_children():
		if child is Control:
			(child as Control).visible = visible
		elif child is Node2D:
			(child as Node2D).visible = visible

func _get_child_combined_minimum_size() -> Vector2:
	var ret = Vector2.ZERO
	for child in get_children():
		if child is Control:
			ret += (child as Control).get_combined_minimum_size()
	return ret
