
import 'package:http/http.dart' as http;

import '../export/exports.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/services/logger.dart';

/// @deprecated This class uses the legacy `http` package and is not integrated
/// with the modern Dio-based API client. Use `Dio` from `lib/shared/data/remote/api_client.dart`
/// instead, which includes authentication, retry logic, and proper error handling.
/// 
/// This class will be removed in a future version.
@Deprecated('Use Dio from lib/shared/data/remote/api_client.dart instead')
class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url, {Map<String, String>? headersData}) async {
    Logger.network('GET', url, headersData ?? {});
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (headersData != null) ...headersData,
        },
      );

      Logger.networkResponse('GET', url, response.statusCode);

      final decodedBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {};

      return {'statusCode': response.statusCode, 'body': decodedBody};
    } on SocketException {
      throw NetworkException.noConnection();
    } on TimeoutException {
      throw NetworkException.timeout();
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<dynamic> postApi(var data, String url, dynamic headerData) async {
    Logger.network('POST', url, headerData as Map<String, dynamic>? ?? {});
    Logger.debug('POST data: $data');
    
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

      if (response.statusCode == 302 || response.statusCode == 301) {}
      Logger.networkResponse('POST', url, response.statusCode);
    } on SocketException {
      throw NetworkException.noConnection();
    } on TimeoutException {
      throw NetworkException.timeout();
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
        Logger.info("Uploading ${files.length} files...");
        request.files.addAll(files);
      } else {
        Logger.warning("No files to upload.");
      }

      Logger.network('POST', url, headers ?? {});

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      Logger.networkResponse('POST', url, streamedResponse.statusCode);

      // Decode JSON response
      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } on SocketException {
      Logger.error("Internet Issue: No Connection");
      throw NetworkException.noConnection();
    } on TimeoutException {
      Logger.error("Request Timeout");
      throw NetworkException.timeout();
    } catch (e, stackTrace) {
      Logger.error("Unknown Error during upload", e, stackTrace);
      throw Exception('Failed to upload');
    }
  }
}
