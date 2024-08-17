import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('FlutterChat'),
        ),
        body: Center(
          child: LoadingAnimationWidget.dotsTriangle(
        color: Colors.black87,
        size: 200,
      ),
        ),
      );
  }
}