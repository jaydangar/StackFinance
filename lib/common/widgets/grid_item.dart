import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  const GridItem(
      {Key key,
      @required this.assetImagePath,
      @required this.title,
      @required this.onClickAction})
      : super(key: key);

  final String assetImagePath;
  final String title;
  final VoidCallback onClickAction;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(2),
          child: GridTile(
            footer: Container(
              padding: EdgeInsets.only(left: 4),
              color: Colors.black45,
              child: Text(
                this.title,
                style: TextStyle(color: Colors.white),
              ),
            ),
            child: Image(
                image: AssetImage(this.assetImagePath), isAntiAlias: true),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClickAction,
            ),
          ),
        )
      ],
    );
  }
}
