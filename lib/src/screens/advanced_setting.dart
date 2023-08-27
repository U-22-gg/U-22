import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
// class AdvancedSettingScreen extends StatelessWidget {

//   const AdvancedSettingScreen({Key? key}) : super(key: key);
class AdvancedSettingScreen extends StatefulWidget {
  const AdvancedSettingScreen({Key? key}) : super(key: key);

  @override
  _AdvancedSettingScreenState createState() => _AdvancedSettingScreenState();
}

class _AdvancedSettingScreenState extends State<AdvancedSettingScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? name;
  String? tel;
  String? address;
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> saveChange() async {
    final uid = _auth.currentUser?.uid ?? '';
    await _firestore
        .collection('profile')
        .doc(uid)
        .set({'name': name, 'address': address, 'tel': tel, 'user_id':uid});
        Fluttertoast.showToast(
        msg: '変更しました',
        toastLength: Toast.LENGTH_LONG,
      );
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid ?? '';
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 2, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text('詳細設定'),
          actions: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(
                Icons.view_headline,
              ),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true, // スクロールを有効化
            tabs: <Widget>[
              Tab(text: 'マイデータ'),
              Tab(text: 'ログアウト'),
            ],
            labelStyle: TextStyle(fontSize: 15.0),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('profile')
                    .doc(uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // データ取得中の表示
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('Document does not exist');
                  }

                  // DocumentSnapshotからデータを取得
                  dynamic documentData = snapshot.data!.data();

                  if (documentData == null ||
                      documentData is! Map<String, dynamic>) {
                    return Text('Invalid document data');
                  }

                  // データがMapとして正しく存在する場合、連想配列（Map）として扱う
                  Map<String, dynamic> dataMap =
                      documentData as Map<String, dynamic>;
                       name = documentData['name'];
                       tel = documentData['tel'];
                       address = documentData['address'];

                  return Column(
                    children: [
                      TextFormField(
                        initialValue: name,
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: InputDecoration(
                          labelText: "名前",
                        ),
                      ),
                      TextFormField(
                        initialValue: tel,
                        onChanged: (value) {
                          tel = value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "TEL",
                        ),
                      ),
                      TextFormField(
                        initialValue: address,
                        onChanged: (value) {
                          address = value;
                        },
                        decoration: InputDecoration(
                          labelText: "住所",
                        ),
                      ),
                      ElevatedButton(onPressed: saveChange, child: Text('Save'))
                    ],
                  );
                },
              ),
            ),
            
            Center(
              child: ElevatedButton(
                child: Text('ログアウト', style: TextStyle(fontSize: 32.0)),
                onPressed: () async {
                  await _signOut(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
