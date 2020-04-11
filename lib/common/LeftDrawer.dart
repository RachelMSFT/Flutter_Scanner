import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlogin/common/Const.dart';
import 'package:flutterlogin/common/Global.dart';

///左侧导航菜单
class LeftDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    List childList = <Widget>[];
    childList.add(_buildUserAccountDrawer(context));
    childList.add(_buildListTile(context, "条码扫描", "CodeScan",Icons.scanner));
    if(Global.connected == true){
      childList.add(_buildListTile(context, "数据重送", "ReSend",Icons.cloud_upload));
      if(Const.admin_role == Global.currentRole){
        childList.add(_buildListTile(context, "在岗信息查看", "ShowOnlineInfo", Icons.calendar_view_day));
      }
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: childList,
      ),
    );
  }


  ///构建汉堡按钮
  Container buildHamburgerBtn(BuildContext context,GlobalKey<ScaffoldState> _scaffoldKey){
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: RawMaterialButton(
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
        child: new Icon(
          Icons.menu,
          size: 25.0,
        ),
      ),
    );
  }


  ///构建用户账户头部
  UserAccountsDrawerHeader _buildUserAccountDrawer(BuildContext context){
    return UserAccountsDrawerHeader(
      accountName: Text(Global.currentLoginUser,style: TextStyle(fontSize: 20),),
      accountEmail: null,
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage("lib/images/avatar.jpg"),
      ),
    );
  }


  ///构建菜单项
  ListTile _buildListTile(BuildContext context, String title, String router,IconData icons){
    return ListTile(
      title: Text(title),
      leading: Container(
        child: RawMaterialButton(
          child: new Icon(
            icons,
            size: 25.0,
          ), onPressed: () {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(router);
        },
        ),
      ),
      onTap: (){
        Navigator.pop(context);
        Navigator.of(context).pushNamed(router);
      },
    );
  }
}