import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSelect{

  var _subject = BehaviorSubject<bool>();
  Stream<bool> get value => _subject.stream;

  ThemeSelect(){
    initTheme();
  }

  void initTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isNight = preferences.getBool("isNight")??false;
    preferences.setBool("isNight", isNight);
    _subject.add(isNight);
  }

  void changeTheme(bool value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isNight", value);
    _subject.add(value);
  }

  void dispose(){
    _subject.close();
  }


}