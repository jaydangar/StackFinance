import 'package:flutter/material.dart';

class GridListWidget extends StatelessWidget {
  const GridListWidget({
    Key key,
    @required this.gridItemList,
  }) : super(key: key);

  final List<Widget> gridItemList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: GridView.builder(
        itemCount: gridItemList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return gridItemList.elementAt(index);
        },
      ),
    );
  }
}
