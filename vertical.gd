class_name Vertical
extends PanelContainer

var _progressbar_container: AnimatedPanelContainer
var _bottom_container: AnimatedPanelContainer
var _content_label_container: AnimatedPanelContainer
var _left_button_panel_container: AnimatedPanelContainer
var _right_button_panel_container: AnimatedPanelContainer
var _size: Vector2
var _is_expanded: bool = true
var _duration: float = 0.6

func _ready():
	_progressbar_container = %ProgressBarContainer
	_bottom_container = %BottomContainer
	_content_label_container = %ContentLabelContainer
	_left_button_panel_container = %LeftButtonPanelContainer
	_right_button_panel_container = %RightButtonPanelContainer

func _on_tween_finished(state: bool) -> void:
	_is_expanded = state
	

func _on_expand_button_pressed() -> void:
	if custom_minimum_size.is_equal_approx(_size):
		return
	if _is_expanded:
		return
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	_left_button_panel_container.connect_tween(tween).animated_transparent_show(_duration)
	_right_button_panel_container.connect_tween(tween).animated_transparent_show(_duration)
	_bottom_container.connect_tween(tween).animated_show(_duration)
	_content_label_container.connect_tween(tween).animated_show(_duration)
	_progressbar_container.connect_tween(tween).animated_show(_duration)
	
	tween.tween_property(self, "custom_minimum_size", _size, _duration)
	tween.finished.connect(_on_tween_finished.bind(true))

func _on_collapse_button_pressed() -> void:
	if not _is_expanded:
		return
	_size = size
	custom_minimum_size = size
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	_left_button_panel_container.connect_tween(tween).animated_transparent_hide(_duration)
	_right_button_panel_container.connect_tween(tween).animated_transparent_hide(_duration)
	_bottom_container.connect_tween(tween).animated_hide(_duration)
	_content_label_container.connect_tween(tween).animated_hide(_duration)
	_progressbar_container.connect_tween(tween).animated_hide(_duration)
	
	tween.tween_property(self, "custom_minimum_size", Vector2(0, 0), _duration)
	tween.finished.connect(_on_tween_finished.bind(false))
