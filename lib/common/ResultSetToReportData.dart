import 'package:flutterlogin/common/Const.dart';
import 'package:flutterlogin/model/ReportData.dart';

///结果集转化为实体对象
class ResultSetToReportData{

  static List<ReportData> transform(List resList){
    Iterator iterator = resList.iterator;
    List<ReportData> dataList = [];
    while(iterator.moveNext()){
      dynamic data = iterator.current;
      dataList.add(ReportData(
        data[Const.uuid],
          data[Const.recData],
          data[Const.recUser],
          DateTime.parse(data[Const.recDate]),
          data[Const.isSend]
      ));
    }
    return dataList;
  }
}