import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService {
  String token = '';
  final String appBaseUrl;
  late Map<String, String> _mainHeaders;
  // ! _mainHeaders mean private mainHeaders
  // todo can only be accessed through get (a method from library get)
  Map<String, String> get mainHeaders => _mainHeaders;

  // ? constructor
  ApiClient({required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    allowAutoSignedCert = true;
    followRedirects = false;
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    this.token = token;
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(String uri) async {
    try {
      Response response = await get(uri, headers: _mainHeaders);
      print("Headers: $_mainHeaders"); // Add this line
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      return response;
    } catch (e) {
      print('Error: $e');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(String uri, dynamic body) async {
  try {
    Response response = await put(uri, body, headers: _mainHeaders);
    return response;
  } catch (e) {
    print('Error: $e');
    return Response(statusCode: 1, statusText: e.toString());
  }
}

Future<Response> deleteData(String uri) async {
  try {
    Response response = await delete(uri, headers: _mainHeaders);
    return response;
  } catch (e) {
    print('Error: $e');
    return Response(statusCode: 1, statusText: e.toString());
  }
}
}
