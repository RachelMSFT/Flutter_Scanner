import 'package:dio/dio.dart';

///Http工具类
///用于请求网络，支持GET和POST请求
class HttpUtil{
  static HttpUtil instance;
  Dio dio;
  BaseOptions options;

  static HttpUtil getInstance(){
    if(instance == null){
      instance = new HttpUtil();
    }
    return instance;
  }

  HttpUtil(){
    options = BaseOptions(
      baseUrl: 'http://www.server.com/api',
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: {},
    );
    dio = new Dio(options);
  }

  get(url, {data, options, cancelToken}) async {
    print('get请求启动! url：$url ,body: $data');
    Response response;
    try {
      response = await dio.get(
        url,
        queryParameters: data,
        cancelToken: cancelToken,
      );
      print('get请求成功!response.data：${response.data}');
      return response.data;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        throw "请求取消";
      }
      print('get请求发生错误：$e');
      throw "网络异常";
    }
  }

  post(url, {data, options, cancelToken}) async {
    print('post请求启动! url：$url ,body: $data');
    Response response;
    try {
      response = await dio.post(
        url,
        data: data,
        cancelToken: cancelToken,
      );
      print('post请求成功!response.data：${response.data}');
      return response.data;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        throw "请求取消";
      }
      print('post请求发生错误：$e');
      throw "出现网络异常";
    }
  }
}