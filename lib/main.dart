import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vector_math/vector_math.dart' show radians;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'FlutterBase',
        home: Scaffold(body: SizedBox.expand(child: RadialMenu())));
  }
}

class RadialMenu extends StatefulWidget {
  const RadialMenu({Key? key}) : super(key: key);

  @override
  createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    // ..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(controller: controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class RadialAnimation extends StatelessWidget {
  RadialAnimation({Key? key, required this.controller})
      : translation = Tween<double>(
          begin: 0.0,
          end: 100.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.elasticOut),
        ),
        scale = Tween<double>(
          begin: 1.5,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.7,
              curve: Curves.decelerate,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> rotation;
  final Animation<double> translation;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, widget) {
        return Transform.rotate(
          angle: radians(rotation.value),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // _buildButton(0,
              //     color: Colors.red, icon: FontAwesomeIcons.thumbtack),
              // _buildButton(45, color: Colors.green, icon:FontAwesomeIcons.sprayCan),
              // _buildButton(90, color: Colors.orange, icon: FontAwesomeIcons.fire),
              // _buildButton(135, color: Colors.blue, icon:FontAwesomeIcons.kiwiBird),
              // _buildButton(180,
              //     color: Colors.black, icon: FontAwesomeIcons.cat),
              // _buildButton(225,
              //     color: Colors.indigo, icon: FontAwesomeIcons.paw),
              // _buildButton(270,
              //     color: Colors.pink, icon: FontAwesomeIcons.bong),
              // _buildButton(315,
              //     color: Colors.yellow, icon: FontAwesomeIcons.bolt),
              Transform.scale(
                scale: scale.value - 1,
                child: Transform.rotate(
                    angle: pi,
                    child: const Text(
                      'Halal',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    )),
              ),
              Transform.scale(
                scale: scale.value,
                child: FloatingActionButton(
                    onPressed: _open,
                    child: const Icon(FontAwesomeIcons.solidDotCircle)),
              )
            ],
          ),
        );
      },
    );
  }

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }

  _buildButton(double angle, {required Color color, required IconData icon}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
            (translation.value) * cos(rad), (translation.value) * sin(rad)),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: _close,
        elevation: 1,
        child: Icon(icon),
      ),
    );
  }
}
