@tool
class_name AnimatedPanelContainer
extends PanelContainer

var _custom_minimum_size: Vector2
var _modulate: Color
var _delay: float = 0
var _tween: Tween

func connect_tween(tween: Tween) -> AnimatedPanelContainer:
	_tween = tween
	_tween.finished.connect(_on_tween_finished)
	return self

func _on_tween_finished() -> void:
	_delay = 0
	_tween = null

func animated_hide(duration: float) -> AnimatedPanelContainer:
	animated_transparent_hide(duration / 2)
	animated_shrink(duration / 2)
	return self

func animated_show(duration: float) -> AnimatedPanelContainer:
	animated_expand(duration / 2)
	animated_transparent_show(duration / 2)
	return self

func animated_transparent_hide(duration: float) -> AnimatedPanelContainer:
	_check_tween()
	_modulate = modulate
	var t = _tween.tween_method(_internal_animated_transparent_hide, modulate, Color(modulate.r, modulate.g, modulate.b, 0), duration)
	if (_delay > 0):
		t.set_delay(duration)
	_delay = duration
	return self

func _internal_animated_transparent_hide(target: Color) -> void:
	_internal_animated_transparent_show_hide(target)
	if modulate.a == 0:
		for child: Control in get_children():
			child.visible = false

func animated_transparent_show(duration: float) -> AnimatedPanelContainer:
	_check_tween()
	var t = _tween.tween_method(_internal_animated_transparent_show, modulate, _modulate, duration)
	if (_delay > 0):
		t.set_delay(duration)
	_delay = duration
	return self

func _internal_animated_transparent_show(target: Color) -> void:
	if modulate.a == 0:
		for child: Control in get_children():
			child.visible = true
	_internal_animated_transparent_show_hide(target)

func _internal_animated_transparent_show_hide(target: Color) -> void:
	modulate = target;

func animated_shrink(duration: float) -> AnimatedPanelContainer:
	_check_tween()
	# save current size
	_custom_minimum_size = size;
	# set minimum size
	custom_minimum_size = size;
	var t = _tween.tween_method(_internal_animated_expand_shrink, size, Vector2(0, 0), duration)
	if (_delay > 0):
		t.set_delay(duration)
	_delay = duration
	return self

func animated_expand(duration: float) -> AnimatedPanelContainer:
	_check_tween()
	var t = _tween.tween_method(_internal_animated_expand_shrink, size, _custom_minimum_size, duration)
	if (_delay > 0):
		t.set_delay(duration)
	_delay = duration
	return self

func _internal_animated_expand_shrink(target: Vector2) -> void:
	custom_minimum_size = target

func _check_tween() -> void:
	if _tween == null:
		printerr("Tween is not set. Call ConnectTween first.")
