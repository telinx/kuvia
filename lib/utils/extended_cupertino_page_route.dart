// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:kuvia/common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart' show Curves;

const double _kBackGestureWidth = 40.0;
const double _kMinFlingVelocity = 1.0; // Screen widths per second.

// An eyeballed value for the maximum time it takes for a page to animate forward
// if the user releases a page mid swipe.
const int _kMaxDroppedSwipePageForwardAnimationTime = 800; // Milliseconds.

// The maximum time for a page to get reset to it's original position if the
// user releases a page mid swipe.
const int _kMaxPageBackAnimationTime = 300; // Milliseconds.

// Barrier color for a XCupertino modal barrier.
const Color _kModalBarrierColor = Color(0x6604040F);

// The duration of the transition used when a modal popup is shown.
// const Duration _kModalPopupTransitionDuration = Duration(milliseconds: 335);
const Duration _kModalPopupTransitionDuration = Duration(milliseconds: 270);

// Offset from offscreen to the right to fully on screen.
final Animatable<Offset> _kRightMiddleTween = Tween<Offset>(
  begin: const Offset(1.0, 0.0),
  end: Offset.zero,
);

// Offset from fully on screen to 1/3 offscreen to the left.
final Animatable<Offset> _kMiddleLeftTween = Tween<Offset>(
  begin: Offset.zero,
  end: const Offset(-1.0/3.0, 0.0),
);

// Offset from offscreen below to fully on screen.
final Animatable<Offset> _kBottomUpTween = Tween<Offset>(
  begin: const Offset(0.0, 1.0),
  end: Offset.zero,
);

// Custom decoration from no shadow to page shadow mimicking iOS page
// transitions using gradients.
final DecorationTween _kGradientShadowTween = DecorationTween(
  begin: _XCupertinoEdgeShadowDecoration.none, // No decoration initially.
  end: const _XCupertinoEdgeShadowDecoration(
    edgeGradient: LinearGradient(
      // Spans 5% of the page.
      begin: AlignmentDirectional(0.90, 0.0),
      end: AlignmentDirectional.centerEnd,
      // Eyeballed gradient used to mimic a drop shadow on the start side only.
      colors: <Color>[
        Color(0x00000000),
        Color(0x04000000),
        Color(0x12000000),
        Color(0x38000000),
      ],
      stops: <double>[0.0, 0.3, 0.6, 1.0],
    ),
  ),
);

/// A modal route that replaces the entire screen with an iOS transition.
///
/// The page slides in from the right and exits in reverse. The page also shifts
/// to the left in parallax when another page enters to cover it.
///
/// The page slides in from the bottom and exits in reverse with no parallax
/// effect for fullscreen dialogs.
///
/// By default, when a modal route is replaced by another, the previous route
/// remains in memory. To free all the resources when this is not necessary, set
/// [maintainState] to false.
///
/// The type `T` specifies the return type of the route which can be supplied as
/// the route is popped from the stack via [Navigator.pop] when an optional
/// `result` can be provided.
///
/// See also:
///
///  * [MaterialPageRoute], for an adaptive [PageRoute] that uses a
///    platform-appropriate transition.
///  * [XCupertinoPageScaffold], for applications that have one page with a fixed
///    navigation bar on top.
///  * [XCupertinoTabScaffold], for applications that have a tab bar at the
///    bottom with multiple pages.
class XCupertinoPageRoute<T> extends PageRoute<T> {
  /// Creates a page route for use in an iOS designed app.
  ///
  /// The [builder], [maintainState], and [fullscreenDialog] arguments must not
  /// be null.
  XCupertinoPageRoute({
    @required this.builder,
    this.title,
    RouteSettings settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
    this.isWideGesture = true,
  }) : assert(builder != null),
       assert(maintainState != null),
       assert(fullscreenDialog != null),
       assert(opaque),
       super(settings: settings, fullscreenDialog: fullscreenDialog);

  final bool isWideGesture;       // 是否是宽收视返回

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  /// A title string for this route.
  ///
  /// Used to auto-populate [XCupertinoNavigationBar] and
  /// [XCupertinoSliverNavigationBar]'s `middle`/`largeTitle` widgets when
  /// one is not manually supplied.
  final String title;

  ValueNotifier<String> _previousTitle;

  /// The title string of the previous [XCupertinoPageRoute].
  ///
  /// The [ValueListenable]'s value is readable after the route is installed
  /// onto a [Navigator]. The [ValueListenable] will also notify its listeners
  /// if the value changes (such as by replacing the previous route).
  ///
  /// The [ValueListenable] itself will be null before the route is installed.
  /// Its content value will be null if the previous route has no title or
  /// is not a [XCupertinoPageRoute].
  ///
  /// See also:
  ///
  ///  * [ValueListenableBuilder], which can be used to listen and rebuild
  ///    widgets based on a ValueListenable.
  ValueListenable<String> get previousTitle {
    assert(
      _previousTitle != null,
      'Cannot read the previousTitle for a route that has not yet been installed',
    );
    return _previousTitle;
  }

  @override
  void didChangePrevious(Route<dynamic> previousRoute) {
    final String previousTitleString = previousRoute is XCupertinoPageRoute
        ? previousRoute.title
        : null;
    if (_previousTitle == null) {
      _previousTitle = ValueNotifier<String>(previousTitleString);
    } else {
      _previousTitle.value = previousTitleString;
    }
    super.didChangePrevious(previousRoute);
  }

  @override
  final bool maintainState;

  @override
  // A relatively rigorous eyeball estimation.
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is XCupertinoPageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return nextRoute is XCupertinoPageRoute && !nextRoute.fullscreenDialog;
  }

  /// True if an iOS-style back swipe pop gesture is currently underway for [route].
  ///
  /// This just check the route's [NavigatorState.userGestureInProgress].
  ///
  /// See also:
  ///
  ///  * [popGestureEnabled], which returns true if a user-triggered pop gesture
  ///    would be allowed.
  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator.userGestureInProgress;
  }

  /// True if an iOS-style back swipe pop gesture is currently underway for this route.
  ///
  /// See also:
  ///
  ///  * [isPopGestureInProgress], which returns true if a XCupertino pop gesture
  ///    is currently underway for specific route.
  ///  * [popGestureEnabled], which returns true if a user-triggered pop gesture
  ///    would be allowed.
  bool get popGestureInProgress => isPopGestureInProgress(this);

  /// Whether a pop gesture can be started by the user.
  ///
  /// Returns true if the user can edge-swipe to a previous route.
  ///
  /// Returns false once [isPopGestureInProgress] is true, but
  /// [isPopGestureInProgress] can only become true if [popGestureEnabled] was
  /// true first.
  ///
  /// This should only be used between frames, not during build.
  bool get popGestureEnabled => _isPopGestureEnabled(this);

  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    // If there's nothing to go back to, then obviously we don't support
    // the back gesture.
    if (route.isFirst)
      return false;
    // If the route wouldn't actually pop if we popped it, then the gesture
    // would be really confusing (or would skip internal routes), so disallow it.
    if (route.willHandlePopInternally)
      return false;
    // If attempts to dismiss this route might be vetoed such as in a page
    // with forms, then do not allow the user to dismiss the route with a swipe.
    if (route.hasScopedWillPopCallback)
      return false;
    // Fullscreen dialogs aren't dismissible by back swipe.
    if (route.fullscreenDialog)
      return false;
    // If we're in an animation already, we cannot be manually swiped.
    if (route.animation.status != AnimationStatus.completed)
      return false;
    // If we're being popped into, we also cannot be swiped until the pop above
    // it completes. This translates to our secondary animation being
    // dismissed.
    if (route.secondaryAnimation.status != AnimationStatus.dismissed)
      return false;
    // If we're in a gesture already, we cannot start another.
    if (isPopGestureInProgress(route))
      return false;

    // Looks like a back gesture would be welcome!
    return true;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final Widget result = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context),
    );
    assert(() {
      if (result == null) {
        throw FlutterError(
          'The builder for route "${settings.name}" returned null.\n'
          'Route builders must never return null.'
        );
      }
      return true;
    }());
    return result;
  }

  // Called by _XCupertinoBackGestureDetector when a pop ("back") drag start
  // gesture is detected. The returned controller handles all of the subsequent
  // drag events.
  static _XCupertinoBackGestureController<T> _startPopGesture<T>(PageRoute<T> route) {
    assert(_isPopGestureEnabled(route));

    return _XCupertinoBackGestureController<T>(
      navigator: route.navigator,
      controller: route.controller, // protected access
    );
  }

  /// Returns a [XCupertinoFullscreenDialogTransition] if [route] is a full
  /// screen dialog, otherwise a [XCupertinoPageTransition] is returned.
  ///
  /// Used by [XCupertinoPageRoute.buildTransitions].
  ///
  /// This method can be applied to any [PageRoute], not just
  /// [XCupertinoPageRoute]. It's typically used to provide a XCupertino style
  /// horizontal transition for material widgets when the target platform
  /// is [TargetPlatform.iOS].
  ///
  /// See also:
  ///
  ///  * [XCupertinoPageTransitionsBuilder], which uses this method to define a
  ///    [PageTransitionsBuilder] for the [PageTransitionsTheme].
  static Widget buildPageTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    {bool isWideGesture : true}
  ) {
    if (route.fullscreenDialog) {
      return XCupertinoFullscreenDialogTransition(
        animation: animation,
        child: child,
      );
    } else {
      return XCupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        // Check if the route has an animation that's currently participating
        // in a back swipe gesture.
        //
        // In the middle of a back gesture drag, let the transition be linear to
        // match finger motions.
        linearTransition: isPopGestureInProgress(route),
        child: _XCupertinoBackGestureDetector<T>(
          enabledCallback: () => _isPopGestureEnabled<T>(route),
          onStartPopGesture: () => _startPopGesture<T>(route),
          child: child,
          isWideGesture: isWideGesture,
        ),
      );
    }
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return buildPageTransitions<T>(this, context, animation, secondaryAnimation, child, isWideGesture: this.isWideGesture);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

/// Provides an iOS-style page transition animation.
///
/// The page slides in from the right and exits in reverse. It also shifts to the left in
/// a parallax motion when another page enters to cover it.
class XCupertinoPageTransition extends StatelessWidget {
  /// Creates an iOS-style page transition.
  ///
  ///  * `primaryRouteAnimation` is a linear route animation from 0.0 to 1.0
  ///    when this screen is being pushed.
  ///  * `secondaryRouteAnimation` is a linear route animation from 0.0 to 1.0
  ///    when another screen is being pushed on top of this one.
  ///  * `linearTransition` is whether to perform primary transition linearly.
  ///    Used to precisely track back gesture drags.
  XCupertinoPageTransition({
    Key key,
    @required Animation<double> primaryRouteAnimation,
    @required Animation<double> secondaryRouteAnimation,
    @required this.child,
    @required bool linearTransition,
  }) : assert(linearTransition != null),
       _primaryPositionAnimation =
           (linearTransition
             ? primaryRouteAnimation
             : CurvedAnimation(
                 // The curves below have been rigorously derived from plots of native
                 // iOS animation frames. Specifically, a video was taken of a page
                 // transition animation and the distance in each frame that the page
                 // moved was measured. A best fit bezier curve was the fitted to the
                 // point set, which is linearToEaseIn. Conversely, easeInToLinear is the
                 // reflection over the origin of linearToEaseIn.
                 parent: primaryRouteAnimation,
                 curve: Curves.linearToEaseOut,
                 reverseCurve: Curves.easeInToLinear,
               )
           ).drive(_kRightMiddleTween),
       _secondaryPositionAnimation =
           (linearTransition
             ? secondaryRouteAnimation
             : CurvedAnimation(
                 parent: secondaryRouteAnimation,
                 curve: Curves.linearToEaseOut,
                 reverseCurve: Curves.easeInToLinear,
               )
           ).drive(_kMiddleLeftTween),
       _primaryShadowAnimation =
           (linearTransition
             ? primaryRouteAnimation
             : CurvedAnimation(
                 parent: primaryRouteAnimation,
                 curve: Curves.linearToEaseOut,
               )
           ).drive(_kGradientShadowTween),
       super(key: key);

  // When this page is coming in to cover another page.
  final Animation<Offset> _primaryPositionAnimation;
  // When this page is becoming covered by another page.
  final Animation<Offset> _secondaryPositionAnimation;
  final Animation<Decoration> _primaryShadowAnimation;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    final TextDirection textDirection = Directionality.of(context);
    return SlideTransition(
      position: _secondaryPositionAnimation,
      textDirection: textDirection,
      transformHitTests: false,
      child: SlideTransition(
        position: _primaryPositionAnimation,
        textDirection: textDirection,
        child: DecoratedBoxTransition(
          decoration: _primaryShadowAnimation,
          child: child,
        ),
      ),
    );
  }
}

/// An iOS-style transition used for summoning fullscreen dialogs.
///
/// For example, used when creating a new calendar event by bringing in the next
/// screen from the bottom.
class XCupertinoFullscreenDialogTransition extends StatelessWidget {
  /// Creates an iOS-style transition used for summoning fullscreen dialogs.
  XCupertinoFullscreenDialogTransition({
    Key key,
    @required Animation<double> animation,
    @required this.child,
  }) : _positionAnimation = CurvedAnimation(
         parent: animation,
         curve: Curves.linearToEaseOut,
         // The curve must be flipped so that the reverse animation doesn't play
         // an ease-in curve, which iOS does not use.
         reverseCurve: Curves.linearToEaseOut.flipped,
       ).drive(_kBottomUpTween),
       super(key: key);

  final Animation<Offset> _positionAnimation;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _positionAnimation,
      child: child,
    );
  }
}

/// This is the widget side of [_XCupertinoBackGestureController].
///
/// This widget provides a gesture recognizer which, when it determines the
/// route can be closed with a back gesture, creates the controller and
/// feeds it the input from the gesture recognizer.
///
/// The gesture data is converted from absolute coordinates to logical
/// coordinates by this widget.
///
/// The type `T` specifies the return type of the route with which this gesture
/// detector is associated.
class _XCupertinoBackGestureDetector<T> extends StatefulWidget {
  const _XCupertinoBackGestureDetector({
    Key key,
    @required this.enabledCallback,
    @required this.onStartPopGesture,
    @required this.child,
    this.isWideGesture = true,
  }) : assert(enabledCallback != null),
       assert(onStartPopGesture != null),
       assert(child != null),
       super(key: key);

  final bool isWideGesture;       //是否是宽手势操作

  final Widget child;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<_XCupertinoBackGestureController<T>> onStartPopGesture;

  @override
  _XCupertinoBackGestureDetectorState<T> createState() => _XCupertinoBackGestureDetectorState<T>();
}

class _XCupertinoBackGestureDetectorState<T> extends State<_XCupertinoBackGestureDetector<T>> {
  _XCupertinoBackGestureController<T> _backGestureController;

  HorizontalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController.dragUpdate(_convertToLogical(details.primaryDelta / context.size.width));
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController.dragEnd(_convertToLogical(details.velocity.pixelsPerSecond.dx / context.size.width));
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    // This can be called even if start is not called, paired with the "down" event
    // that we don't consider here.
    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback())
      _recognizer.addPointer(event);
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    // For devices with notches, the drag area needs to be larger on the side
    // that has the notch.
    double dragAreaWidth = Directionality.of(context) == TextDirection.ltr ?
                           MediaQuery.of(context).padding.left :
                           MediaQuery.of(context).padding.right;
    // dragAreaWidth = max(dragAreaWidth, _kBackGestureWidth);
    dragAreaWidth = widget.isWideGesture ?  max(dragAreaWidth, AppConfig.kBackGestureWidth) : max(dragAreaWidth, _kBackGestureWidth);
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0.0,
          width: dragAreaWidth,
          top: 0.0,
          bottom: 0.0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

/// A controller for an iOS-style back gesture.
///
/// This is created by a [XCupertinoPageRoute] in response from a gesture caught
/// by a [_XCupertinoBackGestureDetector] widget, which then also feeds it input
/// from the gesture. It controls the animation controller owned by the route,
/// based on the input provided by the gesture detector.
///
/// This class works entirely in logical coordinates (0.0 is new page dismissed,
/// 1.0 is new page on top).
///
/// The type `T` specifies the return type of the route with which this gesture
/// detector controller is associated.
class _XCupertinoBackGestureController<T> {
  /// Creates a controller for an iOS-style back gesture.
  ///
  /// The [navigator] and [controller] arguments must not be null.
  _XCupertinoBackGestureController({
    @required this.navigator,
    @required this.controller,
  }) : assert(navigator != null),
       assert(controller != null) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  /// The drag gesture has changed by [fractionalDelta]. The total range of the
  /// drag should be 0.0 to 1.0.
  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  /// The drag gesture has ended with a horizontal motion of
  /// [fractionalVelocity] as a fraction of screen width per second.
  void dragEnd(double velocity) {
    // Fling in the appropriate direction.
    // AnimationController.fling is guaranteed to
    // take at least one frame.
    //
    // This curve has been determined through rigorously eyeballing native iOS
    // animations.
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    bool animateForward;

    // If the user releases the page before mid screen with sufficient velocity,
    // or after mid screen, we should animate the page out. Otherwise, the page
    // should be animated back in.
    if (velocity.abs() >= _kMinFlingVelocity)
      animateForward = velocity <= 0;
    else
      animateForward = controller.value > 0.5;

    if (animateForward) {
      // The closer the panel is to dismissing, the shorter the animation is.
      // We want to cap the animation time, but we want to use a linear curve
      // to determine it.
      final int droppedPageForwardAnimationTime = min(
        lerpDouble(_kMaxDroppedSwipePageForwardAnimationTime, 0, controller.value).floor(),
        _kMaxPageBackAnimationTime,
      );
      controller.animateTo(1.0, duration: Duration(milliseconds: droppedPageForwardAnimationTime), curve: animationCurve);
    } else {
      // This route is destined to pop at this point. Reuse navigator's pop.
      navigator.pop();

      // The popping may have finished inline if already at the target destination.
      if (controller.isAnimating) {
        // Otherwise, use a custom popping animation duration and curve.
        final int droppedPageBackAnimationTime = lerpDouble(0, _kMaxDroppedSwipePageForwardAnimationTime, controller.value).floor();
        controller.animateBack(0.0, duration: Duration(milliseconds: droppedPageBackAnimationTime), curve: animationCurve);
      }
    }

    if (controller.isAnimating) {
      // Keep the userGestureInProgress in true state so we don't change the
      // curve of the page transition mid-flight since XCupertinoPageTransition
      // depends on userGestureInProgress.
      AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (AnimationStatus status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}

// A custom [Decoration] used to paint an extra shadow on the start edge of the
// box it's decorating. It's like a [BoxDecoration] with only a gradient except
// it paints on the start side of the box instead of behind the box.
//
// The [edgeGradient] will be given a [TextDirection] when its shader is
// created, and so can be direction-sensitive; in this file we set it to a
// gradient that uses an AlignmentDirectional to position the gradient on the
// end edge of the gradient's box (which will be the edge adjacent to the start
// edge of the actual box we're supposed to paint in).
class _XCupertinoEdgeShadowDecoration extends Decoration {
  const _XCupertinoEdgeShadowDecoration({ this.edgeGradient });

  // An edge shadow decoration where the shadow is null. This is used
  // for interpolating from no shadow.
  static const _XCupertinoEdgeShadowDecoration none =
      _XCupertinoEdgeShadowDecoration();

  // A gradient to draw to the left of the box being decorated.
  // Alignments are relative to the original box translated one box
  // width to the left.
  final LinearGradient edgeGradient;

  // Linearly interpolate between two edge shadow decorations decorations.
  //
  // The `t` argument represents position on the timeline, with 0.0 meaning
  // that the interpolation has not started, returning `a` (or something
  // equivalent to `a`), 1.0 meaning that the interpolation has finished,
  // returning `b` (or something equivalent to `b`), and values in between
  // meaning that the interpolation is at the relevant point on the timeline
  // between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  // 1.0, so negative values and values greater than 1.0 are valid (and can
  // easily be generated by curves such as [Curves.elasticInOut]).
  //
  // Values for `t` are usually obtained from an [Animation<double>], such as
  // an [AnimationController].
  //
  // See also:
  //
  //  * [Decoration.lerp].
  static _XCupertinoEdgeShadowDecoration lerp(
    _XCupertinoEdgeShadowDecoration a,
    _XCupertinoEdgeShadowDecoration b,
    double t,
  ) {
    assert(t != null);
    if (a == null && b == null)
      return null;
    return _XCupertinoEdgeShadowDecoration(
      edgeGradient: LinearGradient.lerp(a?.edgeGradient, b?.edgeGradient, t),
    );
  }

  @override
  _XCupertinoEdgeShadowDecoration lerpFrom(Decoration a, double t) {
    if (a is! _XCupertinoEdgeShadowDecoration)
      return _XCupertinoEdgeShadowDecoration.lerp(null, this, t);
    return _XCupertinoEdgeShadowDecoration.lerp(a, this, t);
  }

  @override
  _XCupertinoEdgeShadowDecoration lerpTo(Decoration b, double t) {
    if (b is! _XCupertinoEdgeShadowDecoration)
      return _XCupertinoEdgeShadowDecoration.lerp(this, null, t);
    return _XCupertinoEdgeShadowDecoration.lerp(this, b, t);
  }

  @override
  _XCupertinoEdgeShadowPainter createBoxPainter([ VoidCallback onChanged ]) {
    return _XCupertinoEdgeShadowPainter(this, onChanged);
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType)
      return false;
    final _XCupertinoEdgeShadowDecoration typedOther = other;
    return edgeGradient == typedOther.edgeGradient;
  }

  @override
  int get hashCode => edgeGradient.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<LinearGradient>('edgeGradient', edgeGradient));
  }
}

/// A [BoxPainter] used to draw the page transition shadow using gradients.
class _XCupertinoEdgeShadowPainter extends BoxPainter {
  _XCupertinoEdgeShadowPainter(
    this._decoration,
    VoidCallback onChange,
  ) : assert(_decoration != null),
      super(onChange);

  final _XCupertinoEdgeShadowDecoration _decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final LinearGradient gradient = _decoration.edgeGradient;
    if (gradient == null)
      return;
    // The drawable space for the gradient is a rect with the same size as
    // its parent box one box width on the start side of the box.
    final TextDirection textDirection = configuration.textDirection;
    assert(textDirection != null);
    double deltaX;
    switch (textDirection) {
      case TextDirection.rtl:
        deltaX = configuration.size.width;
        break;
      case TextDirection.ltr:
        deltaX = -configuration.size.width;
        break;
    }
    final Rect rect = (offset & configuration.size).translate(deltaX, 0.0);
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect, textDirection: textDirection);

    canvas.drawRect(rect, paint);
  }
}

class _XCupertinoModalPopupRoute<T> extends PopupRoute<T> {
  _XCupertinoModalPopupRoute({
    this.builder,
    this.barrierLabel,
    this.isWideGesture = false,
    RouteSettings settings,
  }) : super(settings: settings);

  final bool isWideGesture;

  final WidgetBuilder builder;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => _kModalBarrierColor;

  @override
  bool get barrierDismissible => true;

  @override
  bool get semanticsDismissible => false;

  @override
  Duration get transitionDuration => _kModalPopupTransitionDuration;

  Animation<double> _animation;

  Tween<Offset> _offsetTween;

  @override
  Animation<double> createAnimation() {
    assert(_animation == null);
    _animation = CurvedAnimation(
      parent: super.createAnimation(),

      // These curves were initially measured from native iOS horizontal page
      // route animations and seemed to be a good match here as well.
      // curve: Curves.linearToEaseOut,
      // reverseCurve: Curves.linearToEaseOut.flipped,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );
    _offsetTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    );
    return _animation;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }


  static _XCupertinoBackGestureController<T> _startPopGesture<T>(PopupRoute<T> route) {
    return _XCupertinoBackGestureController<T>(
      navigator: route.navigator,
      controller: route.controller, // protected access
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionalTranslation(
        translation: _offsetTween.evaluate(_animation),
        // child: child,
        child: _XCupertinoBackGestureDetector<T>(
          enabledCallback: () => true,
          onStartPopGesture: () => _startPopGesture<T>(this),
          child: child,
          isWideGesture: this.isWideGesture,
        ),
      ),
    );
  }
}

/// Shows a modal iOS-style popup that slides up from the bottom of the screen.
///
/// Such a popup is an alternative to a menu or a dialog and prevents the user
/// from interacting with the rest of the app.
///
/// The `context` argument is used to look up the [Navigator] for the popup.
/// It is only used when the method is called. Its corresponding widget can be
/// safely removed from the tree before the popup is closed.
///
/// The `builder` argument typically builds a [XCupertinoActionSheet] widget.
/// Content below the widget is dimmed with a [ModalBarrier]. The widget built
/// by the `builder` does not share a context with the location that
/// `showXCupertinoModalPopup` is originally called from. Use a
/// [StatefulBuilder] or a custom [StatefulWidget] if the widget needs to
/// update dynamically.
///
/// Returns a `Future` that resolves to the value that was passed to
/// [Navigator.pop] when the popup was closed.
///
/// See also:
///
///  * [ActionSheet], which is the widget usually returned by the `builder`
///    argument to [showXCupertinoModalPopup].
///  * <https://developer.apple.com/design/human-interface-guidelines/ios/views/action-sheets/>
Future<T> showXCupertinoModalPopup<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  bool isWideGesture : false,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    _XCupertinoModalPopupRoute<T>(
      builder: builder,
      barrierLabel: 'Dismiss',
      isWideGesture: isWideGesture,
    ),
  );
}

Future<T> showXCupertinoModalReplacement<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  return Navigator.of(context, rootNavigator: true).pushReplacement(
    _XCupertinoModalPopupRoute<T>(
      builder: builder,
      barrierLabel: 'Dismiss',
    ),
  );
}

// The curve and initial scale values were mostly eyeballed from iOS, however
// they reuse the same animation curve that was modeled after native page
// transitions.
final Animatable<double> _dialogScaleTween = Tween<double>(begin: 1.3, end: 1.0)
  .chain(CurveTween(curve: Curves.linearToEaseOut));

Widget _buildXCupertinoDialogTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  final CurvedAnimation fadeAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeInOut,
  );
  if (animation.status == AnimationStatus.reverse) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
  return FadeTransition(
    opacity: fadeAnimation,
    child: ScaleTransition(
      child: child,
      scale: animation.drive(_dialogScaleTween),
    ),
  );
}

/// Displays an iOS-style dialog above the current contents of the app, with
/// iOS-style entrance and exit animations, modal barrier color, and modal
/// barrier behavior (the dialog is not dismissible with a tap on the barrier).
///
/// This function takes a `builder` which typically builds a [XCupertinoDialog]
/// or [XCupertinoAlertDialog] widget. Content below the dialog is dimmed with a
/// [ModalBarrier]. The widget returned by the `builder` does not share a
/// context with the location that `showXCupertinoDialog` is originally called
/// from. Use a [StatefulBuilder] or a custom [StatefulWidget] if the dialog
/// needs to update dynamically.
///
/// The `context` argument is used to look up the [Navigator] for the dialog.
/// It is only used when the method is called. Its corresponding widget can
/// be safely removed from the tree before the dialog is closed.
///
/// Returns a [Future] that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the dialog was closed.
///
/// The dialog route created by this method is pushed to the root navigator.
/// If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// dialog rather than just `Navigator.pop(context, result)`.
///
/// See also:
///
///  * [XCupertinoDialog], an iOS-style dialog.
///  * [XCupertinoAlertDialog], an iOS-style alert dialog.
///  * [showDialog], which displays a Material-style dialog.
///  * [showGeneralDialog], which allows for customization of the dialog popup.
///  * <https://developer.apple.com/ios/human-interface-guidelines/views/alerts/>
Future<T> showXCupertinoDialog<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  assert(builder != null);
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: _kModalBarrierColor,
    // This transition duration was eyeballed comparing with iOS
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return builder(context);
    },
    transitionBuilder: _buildXCupertinoDialogTransitions,
  );
}
