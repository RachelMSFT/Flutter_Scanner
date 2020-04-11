import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlogin/common/AccountUtil.dart';
import 'package:flutterlogin/common/NetworkUtil.dart';
import 'package:flutterlogin/common/ToastUtil.dart';
import 'package:flutterlogin/page/CodeScan.dart';

///登录页
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState(){
    NetworkUtil networkUtil = new NetworkUtil();
    networkUtil.initConnectivity();
    networkUtil.connectivityInitState();
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username, _password;
  bool _isObscure = true;
  Color _eyeColor;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> widgetList = [];
    widgetList.add(_buildScaffold(context));
    if (loading) {
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

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight,
            ),
            _buildTitle(),
            _buildTitleLine(),
            SizedBox(height: 70.0),
            _buildUsernameTextField(),
            SizedBox(height: 30.0),
            _buildPasswordTextField(context),
            SizedBox(height: 60.0),
            _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '登录',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }

  Padding _buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.blue,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  TextFormField _buildUsernameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '请输入用户名',
      ),
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return "用户名不能为空";
        }
      },
      onSaved: (String value) => _username = value,
    );
  }

  TextFormField _buildPasswordTextField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '请输入密码',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _eyeColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
                _eyeColor = _isObscure
                    ? Colors.grey
                    : Theme.of(context).iconTheme.color;
              });
            },
          )),
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return '密码不能为空';
        }
      },
    );
  }

  Align _buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '登录',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.blue,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _doLogin(context);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  _doLogin(BuildContext context) async {
    setState(() {
      loading = true;
    });
    AccountUtil accountUtil = AccountUtil.getInstance();
    bool loginSuccess = await accountUtil.doLogin(_username, _password);
    if(loginSuccess){
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new CodeScanPage()),
      );
    } else {
      setState(() {
        loading = false;
        ToastUtil.showToast("登录失败,请检查用户名、密码以及网络状态");
      });
    }
  }
}
