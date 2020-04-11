import 'package:date_format/date_format.dart';

///日期格式化
class DateFormatter{

  static String format(DateTime dateTime){
    return formatDate(dateTime, [yyyy,'-',mm,'-',dd,' ','HH',':',nn,':',ss]);
  }

  static const CLOCK_INTERVAL = Duration(microseconds: 1000);
  static const ChineseWeekDays = <int, String>{
    1: '一',
    2: '二',
    3: '三',
    4: '四',
    5: '五',
    6: '六',
    7: '日',
  };

  static String pad0(int num) {
    if (num < 10) {
      return '0${num.toString()}';
    }
    return num.toString();
  }

  static DateTime toLocalDateTime(DateTime dateTime){
    Duration duration = new Duration(
      hours: 8
    );
    return dateTime.add(duration);
  }

}