import 'package:StackFinance/common/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  final FirebaseUser user;

  ExplorePage(this.user);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _data = _fetchUserRecords(user);
    return Scaffold(
      appBar: AppBarWidget(title: ConstUtils.appName),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToUploadPage(context, user),
        child: Center(child: Icon(Icons.add)),
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot _snapshot = snapshot.data;
            List<DocumentSnapshot> _data = _snapshot.documents;
            return ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                DateTime _time = getDateFromTimeStamp(_snapshot.documents
                    .elementAt(index)
                    .data[ConstUtils.uploadedAt]);
                String hour = returnTwoIfOne(_time.hour.toString());
                String minute = returnTwoIfOne(_time.minute.toString());
                String seconds = returnTwoIfOne(_time.second.toString());
                return Container(
                  height: MediaQueryUtils(context).height * 0.10,
                  child: ListTile(
                    onTap: () async {
                      await _showUpdateDialog(
                          context, _snapshot.documents.elementAt(index));
                    },
                    onLongPress: () {
                      deleteData(_data, index);
                    },
                    title: Text(
                        _snapshot.documents
                            .elementAt(index)
                            .data[ConstUtils.weight]
                            .toString(),
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: Text(
                        "$hour:$minute:$seconds ${_time.day}-${_time.month}-${_time.year}",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(4),
                  padding: EdgeInsets.all(8),
                  color: Theme.of(context).accentColor,
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        stream: _data,
      ),
    );
  }

  Stream<QuerySnapshot> _fetchUserRecords(FirebaseUser user) {
    Firestore _instance = Firestore.instance;
    Stream<QuerySnapshot> _data = _instance
        .collection(ConstUtils.appName)
        .where(ConstUtils.uploadedBy, isEqualTo: user.email)
        .orderBy(ConstUtils.uploadedAt, descending: true)
        .snapshots();
    return _data;
  }

  void goToUploadPage(BuildContext context, FirebaseUser user) {
    Navigator.pushNamed(context, Routing.HomePageRoute, arguments: user);
  }

  DateTime getDateFromTimeStamp(int timeStamp) {
    return new DateTime.fromMicrosecondsSinceEpoch(timeStamp);
  }

  String returnTwoIfOne(String val) {
    if (val.length == 1) {
      return "0$val";
    }
    return val;
  }

  Future<void> deleteData(List<DocumentSnapshot> documents, int index) async {
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(documents[index].reference);
    });
  }

  Future<void> _showUpdateDialog(
      BuildContext context, DocumentSnapshot documentSnapshot) async {
    TextEditingController _controller = TextEditingController();
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          height: MediaQueryUtils(context).height * 0.25,
          child: AlertDialog(
            title: Text('Update'),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: _controller,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Yes',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  if (validWeight(_controller.text)) {
                    updateWeight(
                        _controller.text.toString(), context, documentSnapshot);
                  } else {
                    SnackbarWidget.showSnackbar(
                        content: Text('Invalid Weight...'), context: context);
                  }
                },
              ),
              TextButton(
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  bool validWeight(String text) {
    return RegExp(r'^[0-9]+(\\.[0-9]+)?$').hasMatch(text);
  }

  void updateWeight(
      String text, BuildContext context, DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> _data = Map();
    _data.putIfAbsent(ConstUtils.weight, () => double.tryParse(text));
    _data.putIfAbsent(
        ConstUtils.uploadedAt, () => DateTime.now().microsecondsSinceEpoch);

    documentSnapshot.reference.updateData(_data);
    Navigator.of(context).pop();
  }
}
