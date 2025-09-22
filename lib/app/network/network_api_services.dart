
import 'package:http/http.dart' as http;

import '../export/exports.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url, {Map<String, String>? headersData}) async {
    if (kDebugMode) {
      print("GET URL: $url");
      print("Headers: $headersData");
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (headersData != null) ...headersData,
        },
      );

      if (kDebugMode) {
        print("Response Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }

      final decodedBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {};

      return {'statusCode': response.statusCode, 'body': decodedBody};
    } on SocketException {
      throw InternetException('No Internet Connection');
    } on TimeoutException {
      throw RequestTimeOut('Request Timed Out');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<dynamic> postApi(var data, String url, dynamic headerData) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }
    dynamic response;
    try {
      response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          if (headerData != null) ...headerData,
        },
      );
      print(headerData);

      if (response.statusCode == 302 || response.statusCode == 301) {}
      print(response.statusCode);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }

  @override
  Future<dynamic> uploadMultipart(
    String url,
    Map<String, String> fields,
    List<http.MultipartFile>? files,
    Map<String, String>? headers,
  ) async {
    try {
      // print("📤 Uploading to: $url");
      // print("📩 Fields: $fields");
      // print("Header $headers");
      // print("Files $files");

      var uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(fields);
      if (headers != null || headers!.isNotEmpty) {
        request.headers.addAll(headers);
      }

      // Add files only if they are present
      if (files != null && files.isNotEmpty) {
        if (kDebugMode) {
          print("📂 Uploading ${files.length} files...");
        }
        request.files.addAll(files);
      } else {
        if (kDebugMode) {
          print("⚠️ No files to upload.");
        }
      }

      print("🚀 Sending Request...");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print(
        "✅ Response Received - Status Code: ${streamedResponse.statusCode}",
      );
      print("📜 Response Body: ${response.body}");

      // Decode JSON response
      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } on SocketException {
      print("❌ Internet Issue: No Connection");
      throw InternetException('');
    } on RequestTimeOut {
      print("⏳ Request Timeout");
      throw RequestTimeOut('');
    } catch (e) {
      print("🔥 Unknown Error: $e");
      throw Exception('Failed to upload');
    }
  }
}
