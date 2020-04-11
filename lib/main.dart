import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterlogin/locale/TranslationsDelegate.dart';
import 'package:flutterlogin/page/CodeScan.dart';
import 'package:flutterlogin/page/Login.dart';
import 'package:flutterlogin/page/Resend.dart';
import 'package:flutterlogin/page/ShowOnlineInfo.dart';
import 'package:flutterlogin/rxdart/BlocProvider.dart';
import 'package:flutterlogin/theme/AppTheme.dart';

void main(){
  runApp(
      BlocProvider(
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget{
  const MyApp();

  @override
  Widget build(BuildContext context) {
    final themeSelect = BlocProvider.of(context);
    return StreamBuilder(
      builder: _builder,
      stream: themeSelect.value,
      initialData: false,
    );
  }

  Widget _builder(BuildContext context,AsyncSnapshot snapshot){
    return MaterialApp(
      title: "AAC Scanner",
      theme: snapshot.data?AppTheme().darkTheme:AppTheme().lightTheme,
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale("zh"), Locale("en")],
      home: LoginPage(),
      routes: <String,WidgetBuilder>{
        'LoginPage':(_) => LoginPage(),
        'CodeScan':(_) => CodeScanPage(),
        'ReSend':(_) => Resend(),
        'ShowOnlineInfo':(_) => ShowOnlineInfo(),
      },
    );
  }

}