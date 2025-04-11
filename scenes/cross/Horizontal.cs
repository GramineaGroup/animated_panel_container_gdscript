using Godot;
using System;

public partial class Horizontal : PanelContainer
{
    private PanelContainer _progressBarContainer;
    private PanelContainer _bottomContainer;
    private PanelContainer _contentLabelContainer;
    private PanelContainer _leftButtonPanelContainer;
    private PanelContainer _rightButtonPanelContainer;
    private Vector2 _size;
    private bool _isExpanded = true;
    private double _duration = 0.6;
    public override void _Ready()
    {
        _progressBarContainer = GetNode<PanelContainer>("%ProgressBarContainer");
        _bottomContainer = GetNode<PanelContainer>("%BottomContainer");
        _contentLabelContainer = GetNode<PanelContainer>("%ContentLabelContainer");
        _leftButtonPanelContainer = GetNode<PanelContainer>("%LeftButtonPanelContainer");
        _rightButtonPanelContainer = GetNode<PanelContainer>("%RightButtonPanelContainer");
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }

    private void OnExpandButtonPressed()
    {
        if (CustomMinimumSize.Equals(_size)) return;
        if (_isExpanded) return;
        var tween = CreateTween().SetParallel(true).SetTrans(Tween.TransitionType.Cubic).SetEase(Tween.EaseType.InOut);

        (_leftButtonPanelContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_transparent_show", [_duration]);
        (_rightButtonPanelContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_transparent_show", [_duration]);
        (_bottomContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_show", [_duration]);
        (_contentLabelContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_show", [_duration]);
        (_progressBarContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_show", [_duration]);

        tween.TweenProperty(this, "custom_minimum_size", _size, _duration);
        tween.Finished += () => _isExpanded = true;
    }

    private void OnCollapseButtonPressed()
    {
        if (!_isExpanded) return;
        // save size
        _size = Size;
        // set minimum size
        CustomMinimumSize = Size;
        var tween = CreateTween().SetParallel(true).SetTrans(Tween.TransitionType.Cubic).SetEase(Tween.EaseType.InOut);

        (_leftButtonPanelContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_transparent_hide", [_duration]);
        (_rightButtonPanelContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_transparent_hide", [_duration]);
        (_bottomContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_hide", [_duration]);
        (_contentLabelContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_hide", [_duration]);
        (_progressBarContainer.Call("create_new_tween").Obj as PanelContainer).Call("animated_hide", [_duration]);

        tween.TweenProperty(this, "custom_minimum_size", new Vector2(0, 0), _duration);
        tween.Finished += () => _isExpanded = false;
    }
}
