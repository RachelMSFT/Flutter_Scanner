import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutterlogin/common/FileUtil.dart';

import 'Const.dart';
import 'Global.dart';

///账户工具类
class AccountUtil{

  static AccountUtil _accountUtil = new AccountUtil();

   static logOff(BuildContext context) {
     Global.currentLoginStatus = 'inactive';
     Global.currentLoginUser = null;
     Navigator.of(context)
         .pushNamedAndRemoveUntil("LoginPage", (Route<dynamic> route) => false);
   }

   ///单例模式
   static getInstance(){
     if(_accountUtil == null){
       _accountUtil = new AccountUtil();
     }
     return _accountUtil;
   }


   ///离线状态下验证上一次登录用户
   Future<bool> validateLocalAccount(String username,String password) async{
     FileUtil fileUtil = new FileUtil();
     File file = await fileUtil.getFile("account.conf");
     String content = file.readAsStringSync();
     print("读取到文件内容："+content);
     if(content == null){
       return false;
     }else{
       Map<String,String> dataMap = new Map<String,String>.from(json.decode(content));
       bool usernameCorrect = false;
       bool passwordCorrect = false;
       dataMap.forEach((key,value){
         if('username'==key && username == value){
           usernameCorrect = true;
         }
         if('password' == key && password == value){
           passwordCorrect = true;
         }
       });
       if(usernameCorrect && passwordCorrect){
         return true;
       }else{
         return false;
       }
     }
   }


   ///登录成功后，保存最新的用户凭据用于下次离线状态校验
   void saveLatestUserCredential(String username,String password) async{
     FileUtil fileUtil = new FileUtil();
     File file = await fileUtil.getFile("account.conf");
     String data = "{\"username\":\""+username+"\",\"password\":\""+password+"\"}";
     print("向文件写入数据："+data);
     file.writeAsStringSync(data);
   }


   ///用户登录
   ///首先验证是否超级管理员，若是，则直接登录，否则进入正常验证流程
   ///网络连接的状态下，联网验证
   ///网络断开的状态下，本地验证上一次登录的用户信息
   ///认证成功后，
   Future<bool> doLogin(String username,String password) async{
     AccountUtil accountUtil = AccountUtil.getInstance();
     if (username == Const.globalAdmin && password == Const.globalAdminPassword) {
       doAfterLogin(username,password, Const.user_role, Global.connected);
       return true;
     }else{
       if(Global.connected) {
         if (username == 'test' && password == 'test') {
            return false;
         }
         bool userLogin = true;
         if(userLogin){
            doAfterLogin(username, password, Global.currentRole, Global.connected);
         }else{
           return false;
         }
       }else{
         bool isUserValid = await accountUtil.validateLocalAccount(username, password);
         if(isUserValid){
           doAfterLogin(username, password, Const.user_role, Global.connected);
           return true;
         }else{
           return false;
         }
       }
     }
     return false;
   }

   ///登录完成后设置全局状态值并写入最新登录用户凭据
   void doAfterLogin(String username,String password,String role,bool connected){
     Global.currentLoginUser = username;
     Global.currentLoginStatus = "active";
     Global.currentRole = role;
     Global.connected = connected;
     AccountUtil accountUtil = AccountUtil.getInstance();
     accountUtil.saveLatestUserCredential(username, password);
   }
}