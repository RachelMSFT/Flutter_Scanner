import 'package:flutter/cupertino.dart';
import 'package:flutterlogin/rxdart/ThemeSelect.dart';

class BlocProvider extends InheritedWidget{

  final ThemeSelect themeSelect = ThemeSelect();

  BlocProvider({Key key,Widget child}) : super(key:key,child:child);

  @override
  bool updateShouldNotify(_) => true;

  static ThemeSelect of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider).themeSelect;

}