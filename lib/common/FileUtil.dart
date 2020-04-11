import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtil{

  Future<File> getFile(String fileName) async{
    String dir = (await getExternalStorageDirectory()).path;
    String path = dir+"/"+fileName;
    return new File(path);
  }
}