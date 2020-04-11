import 'package:flutterlogin/common/Const.dart';
import 'package:flutterlogin/common/DateFormatter.dart';

///扫码数据实体
class ReportData{
  String _uuid;
  String _recData;
  String _recUser;
  DateTime _recDate;
  String _isSend;

  ReportData(this._uuid,this._recData,this._recUser,this._recDate,this._isSend);

  String get uuid => _uuid;
  String get recData => _recData;
  String get recUser => _recUser;
  DateTime get recDate => _recDate;
  String get isSend => _isSend;

  Map<String,dynamic> toMap(){
    var map = new Map<String,String>();
    map[Const.uuid] = _uuid;
    map[Const.recData] = _recData;
    map[Const.recUser] = _recUser;
    map[Const.recDate] = DateFormatter.format(_recDate);
    map[Const.isSend] = _isSend;
    return map;
  }

  ReportData.fromMap(Map<String,dynamic> map){
    this._uuid = map[Const.uuid];
    this._recData = map[Const.recData];
    this._recUser = map[Const.recUser];
    this._recData = map[Const.recData];
    this._isSend = map[Const.isSend];
  }

  void setIsSend(String s) {
    this._isSend = isSend;
  }

}