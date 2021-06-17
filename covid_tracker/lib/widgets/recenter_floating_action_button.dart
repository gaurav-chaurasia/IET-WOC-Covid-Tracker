import 'package:covid_tracker/providers/my_location.dart';
import 'package:covid_tracker/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RefetchFloatingActionButton extends StatefulWidget {
  final GoogleMapController controller;
  final BuildContext ctx;
  RefetchFloatingActionButton(this.controller, this.ctx);
  @override
  _RefetchFloatingActionButtonState createState() =>
      _RefetchFloatingActionButtonState();
}

class _RefetchFloatingActionButtonState
    extends State<RefetchFloatingActionButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation curve;
  final angle = Tween(begin: 0 / 360, end: 720 / 360);
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
        child: RawMaterialButton(
          onPressed: () async {
            if (!_animationController.isAnimating) {
              _myLocation.getCurrentLocation(widget.controller);
              await _animationController.forward();
              _animationController.reset();
            }
          },
          elevation: 4.0,
          fillColor: DarkTheme.button.withOpacity(0.9),
          child: Icon(
            Icons.refresh_outlined,
            size: 30.0,
            color: DarkTheme.green,
          ),
          padding: EdgeInsets.all(12.0),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
