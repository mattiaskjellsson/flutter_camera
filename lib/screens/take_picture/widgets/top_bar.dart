import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Icon icon;
  final Function() toggleFlashState;

  const TopBar({Key? key, required this.icon, required this.toggleFlashState})
      : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: icon,
            onPressed: toggleFlashState,
          ),
        ),
      ],
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  //TODO:: This needs to be thought about, I just added this on random.
  Size get preferredSize => Size(1000.0, 1000.0);
}
