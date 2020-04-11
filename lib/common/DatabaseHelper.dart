import 'dart:async';

import 'package:flutterlogin/model/ReportData.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///嵌入式数据库处理工具
///所有涉及数据库操作在此进行处理
class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableReportData = 'reportDataTable';
  final String uuid = 'uuid';
  final String recData = 'recData';
  final String recUser = 'recUser';
  final String recDate = 'recDate';
  final String isSend = 'isSend';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db;
  }

  ///初始化数据库
  initDb() async {
    String databasedPath = await getDatabasesPath();
    String path = join(databasedPath, "report.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  ///初始化存储结构
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableReportData($uuid TEXT PRIMARY KEY,$recData TEXT ,$recUser TEXT ,$recDate TEXT ,$isSend TEXT )');
  }

  ///插入记录
  Future<int> saveReportData(ReportData reportData) async{
    var dbClient = await db;
    Map<String,String> dataMap = reportData.toMap();
    print("写入"+dataMap.toString());
    var result = await dbClient.insert(
      tableReportData,
      dataMap,
    );
    return result;
  }

  ///关闭连接
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  ///根据UUID查找某一特定记录
  Future<List> getReportData(String uuid) async{
    var dbClient = await db;
    return await dbClient.query(
      tableReportData,
      columns: [uuid,recData,recUser,recDate,isSend],
      limit: 1,
      where: '$uuid = ?',
      whereArgs: [uuid]
    );
  }

  ///更新一条记录
  Future<int> updateReportData(ReportData reportData) async {
    var dbClient = await db;
    return await dbClient.update(tableReportData, reportData.toMap(),
        where: "$uuid = ?", whereArgs: [reportData.uuid]);
  }

  ///删除记录
  Future<int> deleteReportData(String uuid) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableReportData, where: "$uuid = ?", whereArgs: [uuid]);
  }

  ///获取总记录行数
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableReportData'));
  }

  ///获取未处理的记录行数
  Future<int> getUnHandledCount(String recUser) async{
    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery('SELECT COUNT(*) FROM $tableReportData WHERE isSend = ? AND recUser = ?',[false,recUser])
    );
  }

  ///获取所有记录
  Future<List> getAllReportData({int limit,int offset}) async {
    var dbClient = await db;
    var result = await dbClient.query(
      tableReportData,
      columns: [uuid,recData,recUser,recDate,isSend],
      limit: limit,
      offset: offset,
    );
    return result;
  }

  ///按时间排序获取最近的记录
  Future<List> getRecentReportData(String user, int limit,int offset) async{
    var dbClient = await db;
    var result = await dbClient.query(
      tableReportData,
      columns: [uuid,recData,recUser,recDate,isSend],
      limit: limit,
      offset: offset,
      where: '$recUser = ?',
      whereArgs: [user],
      orderBy: "recDate DESC",
    );
    return result;
  }

  ///获取所有状态为未发送的记录
  Future<List> getAllNotSendReportData(String user) async{
    var dbClient = await db;
    var result = await dbClient.query(
      tableReportData,
      columns: [uuid,recData,recUser,recDate,isSend],
      where: '$isSend = ? AND $recUser = ?',
      whereArgs: ['false',user],
    );
    return result;
  }
}
