import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///全局Toast工具
///在任意地点静态调用ToastUtil.showToast()方法传入需要显示的信息即可
///默认在顶部显示
class ToastUtil{
  static ToastUtil instance;

  static getInstance(){
    if(instance == null){
      instance = new ToastUtil();
    }
    return instance;
  }

  static showToast(String msg) async{
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black26,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}