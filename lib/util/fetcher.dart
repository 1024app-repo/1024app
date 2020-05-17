import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../util/constants.dart';
import 'utils.dart';

var userAgent = Platform.isIOS
    ? 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Safari/605.1.15'
    : 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Mobile Safari/537.36';

Dio _dio = Dio();

Dio get dio => _dio;

String gbkDecoder(List<int> responseBytes, RequestOptions options,
    ResponseBody responseBody) {
  return gbk.decode(responseBytes);
}

List<int> gbkEncoder(String request, RequestOptions options) {
  return gbk.encode(options.data);
}

class Fetcher {
  static Future init() async {
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 15000;
    dio.options.baseUrl = BASE_URL;
    dio.options.headers = {
      'user-agent': userAgent,
      'Referer': BASE_URL + '/index.php',
    };
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.validateStatus = (int status) {
      return status == 200;
    };
    dio.options.requestEncoder = gbkEncoder;
    dio.options.responseDecoder = gbkDecoder;

    String cookiePath = await getCookiePath();
    print('DioUtil : http cookie path = $cookiePath');
    CookieJar cj = PersistCookieJar(dir: cookiePath, ignoreExpires: true);
    dio.interceptors.add(CookieManager(cj));
  }

  static Future<Document> invoke(
    String url, {
    String method = 'GET',
    data,
  }) async {
    Response resp = await dio.request(
      "/" + url,
      data: data,
      options: Options(method: method),
    );
    return parse(resp.data);
  }
}
