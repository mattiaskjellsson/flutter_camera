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
            // (_flashState == FlashMode.off
            //     ? Icon(
            //         Icons.flash_off_outlined,
            //         color: Colors.grey[400],
            //         size: 24.0,
            //         semanticLabel: 'Flash on',
            //       )
            //     : Icon(
            //         Icons.flash_on_outlined,
            //         color: Colors.grey[400],
            //         size: 24.0,
            //         semanticLabel: 'Flash off',
            //       )),
            color: Colors.red[500],
            onPressed: toggleFlashState,
          ),
        ),
      ],
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(1000.0, 1000.0);
}
