import 'package:aura/meditate/screens/info_screen.dart';
import 'package:aura/meditate/utils/constants.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? home;
  final bool? info;
  const MyAppBar({Key? key, this.home, this.info}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      leading: home == null
          ? GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_outlined,
                color: black,
              ))
          : null,
      actions: info == null
          ? [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return InfoScreen();
                  }));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.info,
                    color: black,
                  ),
                ),
              ),
            ]
          : null,
    );
  }
}
