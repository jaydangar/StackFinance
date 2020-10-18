import 'package:flutter/material.dart';

class FlatIconButton extends StatelessWidget {
  const FlatIconButton({
    Key key,
    @required this.buttonAction,
    @required this.color,
    @required this.backGroundColor,
    @required this.buttonIcon,
    @required this.iconText,
  }) : super(key: key);

  final IconData buttonIcon;
  final VoidCallback buttonAction;
  final Color color, backGroundColor;
  final String iconText;

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      color: this.backGroundColor,
      onPressed: this.buttonAction,
      icon: Icon(
        this.buttonIcon,
        color: this.color,
      ),
      label: Text(
        this.iconText,
        style: TextStyle(
            color: this.color, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
