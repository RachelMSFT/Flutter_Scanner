import 'package:barcode_scan/barcode_scan.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterlogin/common/BackExit.dart';
import 'package:flutterlogin/common/BaseClock.dart';
import 'package:flutterlogin/common/DatabaseHelper.dart';
import 'package:flutterlogin/common/Global.dart';
import 'package:flutterlogin/common/HttpUtil.dart';
import 'package:flutterlogin/common/LeftDrawer.dart';
import 'package:flutterlogin/common/ResultSetToReportData.dart';
import 'package:flutterlogin/common/ToastUtil.dart';
import 'package:flutterlogin/component/ReportDataList.dart';
import 'package:flutterlogin/model/ReportData.dart';
import 'package:uuid/uuid.dart';

class CodeScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CodeScanState();
  }
}

class _CodeScanState extends State<CodeScanPage> {
  String barCode = "";
  List<ReportData> _history = new List<ReportData>();
  int index = 0;
  int offset = 0;
  int totalCount = 0;
  bool hasMoreData = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getRecentData(0);
  }

  Widget build(BuildContext context) {
    return _buildWillPopScope(context);
  }

  WillPopScope _buildWillPopScope(BuildContext context) {
    return BackExit().buildBody(context, _buildScaffold(context));
  }

  Scaffold _buildScaffold(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        drawer: LeftDrawer().build(context),
        appBar: new AppBar(
          title: new Text("条码扫描"),
          automaticallyImplyLeading: false,
          leading: LeftDrawer().buildHamburgerBtn(context, _scaffoldKey),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              _buildScanButton(context),
              SizedBox(height: 10.0),
              Expanded(
                child: ReportDataList().itemBuilder(_history),
              )
            ],
          ),
        ));
  }

  ///component build section
  Center _buildScanButton(BuildContext context) {
    return new Center(
      child: SizedBox(
        height: 90.0,
        width: 400.0,
        child: Column(
          children: <Widget>[
            BaseClock(),
            SizedBox(height: 5),
            RaisedButton(
              child: Text(
                '扫描',
                style: Theme.of(context).primaryTextTheme.headline,
              ),
              color: Colors.green,
              onPressed: () {
                _scan();
              },
              shape: StadiumBorder(side: BorderSide()),
            ),
          ],
        ),
      ),
    );
  }

  ///扫描条码
  Future _scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barCode = barcode;
        print(barcode);
        _sendToServer();
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          ToastUtil.showToast('无摄像头访问权限');
        });
      } else {
        setState(() {
          ToastUtil.showToast('未知异常：$e');
        });
      }
    } on FormatException {
      setState(() {
        ToastUtil.showToast('调用失败');
      });
    } catch (e) {
      setState(() {
        ToastUtil.showToast('未知错误：$e');
      });
    }
  }

  ///发送数据至服务器
  void _sendToServer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var isSuccess = false;
    if (connectivityResult != ConnectivityResult.none) {
      var httpUtil = new HttpUtil();
      var server = 'http://www.aac.com:8001/api?';
      try {
        server = server + "data=" + barCode;
        var data = await httpUtil.get(server);
        print(data);
        if (data != null && data['status'] == 'success') {
          isSuccess = true;
        }
      } catch (e) {
        ToastUtil.showToast(e.toString());
      }
    } else {
      ToastUtil.showToast("无网络连接，已准备将数据保存至本地，请在连接网络后重新发送");
    }
    var uuidHelper = Uuid();
    print(new DateTime.now().toLocal());
    ReportData reportData = new ReportData(
        uuidHelper.v1(),
        barCode,
        Global.currentLoginUser,
        new DateTime.now().toLocal(),
        isSuccess.toString());
    _dataHandle(reportData);
  }

  ///写入本地数据库
  void _dataHandle(ReportData reportData) async {
    var db = DatabaseHelper();
    index++;
    print('写入一条记录：' + reportData.toMap().toString());
    await db.saveReportData(reportData);
    this.setState(() {
      print(_history.length);
      this._history.add(reportData);
    });
  }

  ///获取最近的数据
  void _getRecentData(int offset) async {
    var db = DatabaseHelper();
    this.offset = this.offset + 10;
    var res =
        await db.getRecentReportData(Global.currentLoginUser, 100, offset);
    List<ReportData> dataList = ResultSetToReportData.transform(res);
    if (res == null || res.length == 0) {
      this.hasMoreData = false;
    } else {
      setState(() {
        print("获取前" + _history.toString());
        _history.addAll(dataList);
        print("获取后" + _history.toString());
      });
    }
  }

  ///获取当前用户的所有未处理数据行数
  void _getTotalCount(String recUser) async {
    var db = DatabaseHelper();
    this.totalCount = await db.getUnHandledCount(recUser);
  }

  ///获取当前用户所有未处理数据
  void _getAllUnhandledData(String recUser) async {
    var db = DatabaseHelper();
    var res = await db.getAllNotSendReportData(Global.currentLoginUser);
    List<ReportData> dataList = ResultSetToReportData.transform(res);
    setState(() {
      _history.addAll(dataList);
    });
  }
}
