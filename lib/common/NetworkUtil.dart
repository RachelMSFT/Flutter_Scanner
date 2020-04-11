import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutterlogin/common/Global.dart';
import 'package:flutterlogin/common/ToastUtil.dart';

///网络工具
///用于进行网络测试
class NetworkUtil{

  Future<bool> isWifiConnected() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.wifi){
      return true;
    }
    return false;
  }

  Future<bool> isCellularConnected() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile){
      return true;
    }
    return false;
  }

  Future<ConnectivityResult> getCurrentNetwork() async{
    return await (Connectivity().checkConnectivity());
  }

  //定义变量（网络状态）
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  //网络初始状态
  connectivityInitState(){
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          if(result == ConnectivityResult.none){
            Global.connected = false;
            ToastUtil.showToast("网络连接错误");
          }
        });
  }
  //网络结束监听
  connectivityDispose(){
    _connectivitySubscription.cancel();
  }
  //网络进行监听
  Future<Null> initConnectivity() async {
    ConnectivityResult connectivityResult;
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
    try {
      connectivityResult = (await Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        Global.connected = true;
        // I am connected to a mobile network.
      } else if (connectivityResult == ConnectivityResult.wifi) {
        Global.connected = true;
        // I am connected to a wifi network.
      }
    } on Exception catch (e) {
      Global.connected = false;
      print(e.toString());
    }
  }
}