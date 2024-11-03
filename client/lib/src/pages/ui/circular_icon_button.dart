import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final Icon icon;
  final Color backgroundColor;
  final void Function() onPressed;

  const CircularIconButton({required this.icon, required this.onPressed, this.backgroundColor = Colors.white,  super.key});

  @override
  Widget build(BuildContext context) {
   return Container(
     width: (icon.size ?? 32) + 16,
     height: (icon.size ?? 32) + 16,
     decoration: BoxDecoration(
       color: backgroundColor, // Background color
       shape: BoxShape.circle, // Shape of the container (optional)
     ),
     child: Center(
       child: IconButton(
           onPressed: onPressed,
           icon:icon),
     ),
   );
  }
}