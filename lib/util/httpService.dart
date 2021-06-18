import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'index.dart' show Token;

class Http {
  static final _baseUrl = 'https://prod.botiga.app';
  static String _token;

  static Map<String, String> _globalHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<void> fetchToken() async {
    _token = await Token.read();
  }

  static Future<dynamic> postAuth(
    String url, {
    Map<String, String> body,
  }) async {
    final response = await http.post(
      '$_baseUrl$url',
      headers: {..._globalHeaders},
      body: body != null ? json.encode(body) : null,
    );

    if (response.headers['authorization'] != null) {
      _token = response.headers['authorization'];
      await Token.write(_token); // save token to persistence storage
    }
    return parse(response);
  }

  static Future<dynamic> get(String url) async {
    final response = await http.get(
      '$_baseUrl$url',
      headers: {'Authorization': _token, ..._globalHeaders},
    );
    return parse(response);
  }

  static Future<dynamic> post(String url,
      {Map<String, String> headers, Map<String, dynamic> body}) async {
    final _headers = headers == null ? {} : headers;
    final response = await http.post(
      '$_baseUrl$url',
      headers: {'Authorization': _token, ..._globalHeaders, ..._headers},
      body: body != null ? json.encode(body) : null,
    );
    return parse(response);
  }

  static Future<dynamic> patch(
    String url, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    final _headers = headers == null ? {} : headers;
    final response = await http.patch(
      '$_baseUrl$url',
      headers: {'Authorization': _token, ..._globalHeaders, ..._headers},
      body: body != null ? json.encode(body) : null,
    );
    return parse(response);
  }

  static Future<dynamic> delete(String url) async {
    final response = await http.delete(
      '$_baseUrl$url',
      headers: {'Authorization': _token, ..._globalHeaders},
    );
    return parse(response);
  }

  static Future<dynamic> postImage(String url, File image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$url'));

    final fileType = image.path.split(".").last;
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType('image', fileType),
    ));

    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Authorization': _token,
    });

    final response = await request.send();
    final responseStr = await response.stream.bytesToString();
    final json = jsonDecode(responseStr);
    return json;
  }

  static dynamic parse(http.Response response) {
    if (response.statusCode == 204) {
      return;
    }

    final data = json.decode(response.body);
    if (response.statusCode >= 500) {
      final msg = data['message'] ?? 'Something went wrong';
      throw HttpException(msg);
    } else if (response.statusCode >= 400) {
      var msg = data['message'] ?? 'Somethig went wrong';
      if (response.statusCode == 422) {
        final info = data['errors'][0];
        msg = '${info['param']} - ${info['msg']}';
      }

      throw FormatException(msg);
    } else {
      return data;
    }
  }

  static String message(dynamic exception) {
    var msg;
    if (exception is SocketException) {
      msg = 'No Internet Connection';
    } else if (exception is HttpException) {
      msg = exception.message;
    } else if (exception is FormatException) {
      msg = exception.message;
    } else {
      msg = exception.toString();
    }
    return msg;
  }
}
