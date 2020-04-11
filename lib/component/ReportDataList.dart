import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlogin/common/DateFormatter.dart';
import 'package:flutterlogin/model/ReportData.dart';

///数据列表构建器
class ReportDataList extends StatelessWidget {
  
  ///Build List
  Widget itemBuilder(List<ReportData> dataList) {
    return ListView.builder(
      itemCount: dataList.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        //if (i.isOdd) return Divider();
        return buildRow(dataList[i]);
      },
      padding: const EdgeInsets.all(16.0),
    );
  }

  ///Build Row
  Widget buildRow(ReportData reportData) {
    final alreadyUploaded = reportData.isSend == 'true' ? true : false;
    final bool uploading = false;
    return ListTile(
      title: Column(
        children: <Widget>[
          Divider(
            color: Colors.grey,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(reportData.recUser),
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(reportData.recData),
                ),
                flex: 3,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(DateFormatter.format(reportData.recDate)),
                ),
                flex: 2,
              ),
            ],
          ),
        ],
      ),
      trailing: Icon(
        alreadyUploaded ? Icons.check : Icons.arrow_upward,
        color: uploading ? Colors.blue : alreadyUploaded ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}