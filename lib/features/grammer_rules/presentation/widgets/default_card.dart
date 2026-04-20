import 'package:flutter/material.dart';

class DefaultCard extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  const DefaultCard({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          elevation: 2,
        ),
        onPressed: onTap,
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 20,
              bottom: 20,
            ),
            alignment: Alignment.centerRight,
            child: child,
          ),
        ),
      ),
    );
  }
}
