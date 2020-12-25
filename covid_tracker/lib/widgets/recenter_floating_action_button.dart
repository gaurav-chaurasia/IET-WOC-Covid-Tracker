import 'package:covid_tracker/providers/MyLocation.dart';
import 'package:covid_tracker/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RecenterFloatingActionButton extends StatefulWidget {
  final GoogleMapController _controller;
  RecenterFloatingActionButton(this._controller);
  @override
  _RecenterFloatingActionButtonState createState() =>
      _RecenterFloatingActionButtonState();
}

class _RecenterFloatingActionButtonState
    extends State<RecenterFloatingActionButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation curve;
  final angle = Tween(begin: 0 / 360, end: 1800 / 360);
  final scaleTween = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
  ]);
  var _myLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myLocation = Provider.of<MyLocation>(context, listen: false);
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      alignment: Alignment.center,
      turns: angle.animate(curve),
      child: ScaleTransition(
        alignment: Alignment.center,
        scale: scaleTween.animate(curve),
        child: InkWell(
          onTap: () async {
            if (!_animationController.isAnimating) {
              _myLocation.getCurrentLocation(context, widget._controller);
              await _animationController.forward();
              _animationController.reset();
            }
          },
          child: CircleAvatar(
            backgroundColor: DarkTheme.primary,
            radius: 26,
            child: Center(
              child: Icon(
                CupertinoIcons.location_circle,
                size: 30,
                color: DarkTheme.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
