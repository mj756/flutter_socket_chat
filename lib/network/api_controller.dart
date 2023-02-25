import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ApiController {
  static final dio = Dio();
  Future<String> downloadFile({required String url}) async {
    String fileName = "${(await getExternalStorageDirectory())?.path}/demo.png";
    await dio.download(
      url,
      fileName,
    );
    return fileName;
  }

  Future<void> postFormData(
      {required String url,
      required Map<String, String> params,
      required String fileName}) async {
    final formData = FormData.fromMap({
      'sender': params['sender'],
      'receiver': params['receiver'],
      'file': await MultipartFile.fromFile(fileName,
          filename: fileName.substring(fileName.lastIndexOf('/') + 1)),
      'messageType': 'file',
      'groupId': params.containsKey('groupId') ? '' : null
    });
    dio.options.headers['content-Type'] = 'multipart/form-data';
    await dio.post(
      url,
      data: formData,
      onSendProgress: (int sent, int total) {},
    );
  }
}
