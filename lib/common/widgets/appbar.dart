import 'package:flutter/material.dart';
import 'package:StackFinance/login/login.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget leadingWidget;
  final String title;

  AppBarWidget({this.leadingWidget, @required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingWidget,
      title: Text(title),
      actions: [
        IconButton(
            icon: Icon(Icons.lock_open_outlined),
            onPressed: () => _logout(context))
      ],
    );
  }

  void _logout(BuildContext context) {
    final PageRouteBuilder _loginRoute = new PageRouteBuilder(
      pageBuilder: (BuildContext context, _, __) {
        return LoginPage();
      },
    );
    Navigator.pushAndRemoveUntil(
        context, _loginRoute, (Route<dynamic> r) => false);
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
