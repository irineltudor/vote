import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
              color: theme.dialogBackgroundColor.withOpacity(0.5), width: 2),
          boxShadow: ([
            BoxShadow(
                color: theme.dialogBackgroundColor.withOpacity(0.8),
                blurRadius: 1.5)
          ])),
      child: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          highlightColor: Colors.transparent,
          icon: IconTheme(
              data: Theme.of(context).iconTheme,
              child: const Icon(
                Icons.menu,
              ))),
    );
  }
}
