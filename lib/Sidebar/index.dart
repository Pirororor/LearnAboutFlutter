import 'package:flutter/material.dart';
import '../common/routes.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final bool isCurrentRoute;
  final void Function() onTap;

  const SidebarItem({
    required this.title,
    required this.isCurrentRoute,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCurrentRoute) {
      return ListTile(
        title: Text(title),
        tileColor: Colors.lightBlueAccent,
      );
    } else {
      return ListTile(
        title: Text(title),
        onTap: onTap,
      );
    }
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Billy Test App'),
            )),
        SidebarItem(
          title: 'Facebook Login Test',
          isCurrentRoute: currentRoute == Routes.facebookAgeCountdown,
          onTap: () {
            Navigator.pushReplacementNamed(
                context, Routes.facebookAgeCountdown);
          },
        ),
        SidebarItem(
          title: 'Camera Test',
          isCurrentRoute: currentRoute == Routes.cameraTest,
          onTap: () {
            Navigator.pushReplacementNamed(context, Routes.cameraTest);
          },
        ),
      ],
    ));
  }
}
