import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlogin/common/BackExit.dart';
import 'package:flutterlogin/common/DatabaseHelper.dart';
import 'package:flutterlogin/common/Global.dart';
import 'package:flutterlogin/common/HttpUtil.dart';
import 'package:flutterlogin/common/LeftDrawer.dart';
import 'package:flutterlogin/common/ResultSetToReportData.dart';
import 'package:flutterlogin/common/ToastUtil.dart';
import 'package:flutterlogin/component/ReportDataList.dart';
import 'package:flutterlogin/model/ReportData.dart';

///数据重送页
class Resend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    _ResendState _resendState = new _ResendState();
    _resendState._getPreparedData();
    return _resendState;
  }
}

class _ResendState extends State<Resend> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ReportData> _history = new List<ReportData>();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(_buildWillPopScope(context));
    if (uploading) {
      widgetList.add(Opacity(
        opacity: 0.6,
        child: ModalBarrier(
          color: Colors.black54,
        ),
      ));
      widgetList.add(Center(
        child: CircularProgressIndicator(),
      ));
    }
    return Stack(
      children: widgetList,
    );
  }

  WillPopScope _buildWillPopScope(BuildContext context) {
    return BackExit().buildBody(context, _buildScaffold(context));
  }

  @override
  initState() {
    super.initState();
    _getPreparedData();
  }

  ///构建Scaffold
  Scaffold _buildScaffold(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        drawer: LeftDrawer().build(context),
        appBar: AppBar(
          title: Text('数据重送'),
          automaticallyImplyLeading: false,
          leading: LeftDrawer().buildHamburgerBtn(context, _scaffoldKey),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.cloud_upload), onPressed: _uploadAll),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ReportDataList().itemBuilder(_history),
            )
          ],
        ));
  }

  ///获取准备发送的数据
  void _getPreparedData() async {
    var db = DatabaseHelper();
    List<dynamic> resList =
        await db.getAllNotSendReportData(Global.currentLoginUser);
    this._history = ResultSetToReportData.transform(resList);
  }

  ///全部上传
  void _uploadAll() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ToastUtil.showToast("无网络连接，请连接网络后重新尝试发送");
    } else {
      for (int i = 0; i < _history.length; i++) {
        _uploadOne(_history[i]);
        setState(() {
          _history[i].setIsSend('true');
        });
      }
    }
  }

  void _uploadOne(ReportData reportData) async {
    var httpUtil = new HttpUtil();
    var server = 'http://www.aac.com:8001/api?';
    try {
      server = server + "data=" + reportData.recData;
      var data = httpUtil.get(server);
      print(data);
      if (data != null && data['status'] == 'success') {
        _updateStatus(reportData);
      }
    } catch (e) {
      ToastUtil.showToast(e.toString());
    }
  }

  void _updateStatus(ReportData reportData) async {
    var db = DatabaseHelper();
    db.updateReportData(reportData);
  }
}
