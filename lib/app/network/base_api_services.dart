import 'package:http/http.dart' as http;

/// @deprecated This abstract class is part of the legacy network layer.
/// Use `Dio` from `lib/shared/data/remote/api_client.dart` instead.
/// 
/// This class will be removed in a future version.
@Deprecated('Use Dio from lib/shared/data/remote/api_client.dart instead')
abstract class BaseApiServices {
  Future<dynamic> getApi(String url);

  Future<dynamic> postApi(dynamic data, String url, dynamic headerData);

  Future<dynamic> uploadMultipart(
    String url,
    Map<String, String> fields,
    List<http.MultipartFile> files,
    Map<String, String> headers,
  );
}
