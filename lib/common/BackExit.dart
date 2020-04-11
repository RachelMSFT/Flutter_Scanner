import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AccountUtil.dart';

///全局退出
///拦截用户的返回请求，并替换为注销的动作
class BackExit extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }


  ///构建WillPopScope
  WillPopScope buildBody(BuildContext context, Scaffold scaffold){
    return WillPopScope(
      onWillPop: () => _showMessage(context, "信息", "退出登录？"),
      child: scaffold,
    );
  }

  ///登出确认
  Future<void> _showMessage(
      BuildContext context, String title, String message) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  AccountUtil.logOff(context);
                },
              )
            ],
          );
        });
  }

}
