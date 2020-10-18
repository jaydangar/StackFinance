import 'package:StackFinance/common/common.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatefulWidget {
  final double progress;

  AlertDialogWidget({@required this.progress});

  @override
  _AlertDialogWidgetState createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  Widget build(BuildContext context) {
    print(widget.progress);
    return AlertDialog(
      content: Container(
        width: MediaQueryUtils(context).width * 0.8,
        height: MediaQueryUtils(context).height * 0.15,
        child: Row(
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  value: widget.progress,
                ),
              ),
              flex: 1,
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.all(4),
                child: Text(
                  '${widget.progress.floor()} % completed...',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Theme.of(context).textTheme.headline5.fontSize),
                ),
              ),
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
