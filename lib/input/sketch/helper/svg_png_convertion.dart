import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:quick_log/quick_log.dart';

final svg_convertion_endpoint = Platform.environment.containsKey('SAC_ENDPOINT')
    ? Platform.environment['SAC_ENDPOINT']
    : 'http://localhost:4000/vector/local';

Logger log = Logger('Image conversion');

/// Converts the svg to a png by passing the uuid to the local sketchtool
Future<Uint8List> convertImage(String uuid, num width, num height) async {
  try {
    var body = {
      'uuid': uuid,
      'path': MainInfo().sketchPath,
      'width': width,
      'height': height
    };

    var response = await http.post(
      svg_convertion_endpoint,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      var bodyMap = jsonDecode(response.body);
      log.error(bodyMap['error']);
    }
    return response?.bodyBytes;
  } catch (e) {
    log.error(e.message);
  }
  return null;
}
