import 'package:StackFinance/common/common.dart';
import 'package:StackFinance/common/utils/mediaquery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:toast/toast.dart';

/*
 * Shows home page for entering user weight
*/
class HomePage extends StatefulWidget {
  final FirebaseUser user;

  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double weightValue = 0;
  TextEditingController _controller;
  final MAX_WEIGHT = 150.0;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: ConstUtils.appName),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          Container(
            height: MediaQueryUtils(context).height * 0.6,
            alignment: Alignment.center,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            child: CircularPercentIndicator(
              radius: MediaQueryUtils(context).width * 0.6,
              animation: true,
              animateFromLastPercent: true,
              animationDuration: 1200,
              progressColor: Theme.of(context).accentColor,
              percent: (weightValue / MAX_WEIGHT),
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: 16,
              center: Text(
                "${weightValue.toInt()} / $MAX_WEIGHT",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 4)),
                  hintText: "Weight",
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: Icon(Icons.done),
                  enabledBorder: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8)),
              controller: _controller,
              onSubmitted: (value) {
                double _weight = double.parse(value);
                if (_weight <= MAX_WEIGHT && _weight > 0) {
                  setState(() {
                    weightValue = double.parse(value);
                  });
                  return;
                }
                Toast.show(
                    "Weight value should be in between 0 and 150.", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                height: 56,
                width: MediaQueryUtils(context).width * 0.5,
                child: FlatIconButton(
                    buttonIcon: Icons.add_circle_outline,
                    iconText: 'Submit',
                    color: Theme.of(context).buttonColor,
                    backGroundColor: Theme.of(context).accentColor,
                    buttonAction: () {
                      setState(() {
                        String weights = _controller.text;
                        if (double.tryParse(weights) <= MAX_WEIGHT &&
                            double.tryParse(weights) > 0) {
                          setState(() {
                            weightValue = double.parse(_controller.text);
                          });
                          return;
                        }
                      });
                      submitWeight(weightValue, widget.user);
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void submitWeight(double weightValue, FirebaseUser _user) {
    Map<String, dynamic> _data = Map();
    _data.putIfAbsent(ConstUtils.weight, () => weightValue);
    _data.putIfAbsent(ConstUtils.uploadedBy, () => _user.email);
    _data.putIfAbsent(
        ConstUtils.uploadedAt, () => DateTime.now().microsecondsSinceEpoch);

    Firestore.instance.collection(ConstUtils.appName).add(_data).then((value) {
      gotoExplorePage(context, widget.user);
    }, onError: (e) => Toast.show(e.toString(), context));
  }

  void gotoExplorePage(BuildContext context, FirebaseUser user) {
    Navigator.popAndPushNamed(context, Routing.ExplorePageRoute, arguments: user);
  }
}
