import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../services/vchat_app_service.dart';
import '../../helpers/helpers.dart';
import '../server_config.dart';
import 'app_http_exception.dart';

class CustomDio {
  final Dio dio = Dio();

  CustomDio() {
    dio.options.baseUrl = ServerConfig.SERVER_IP;
    dio.options.validateStatus = (_) => true;
    dio.options.headers = {
      'authorization': VChatAppService.to.vChatUser != null
          ? VChatAppService.to.vChatUser!.accessToken.toString()
          : ""
    };

    dio.options.sendTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.options.connectTimeout = 10000;
  }

  Future<Response> upload(
      {required String apiEndPoint,
      required String filePath,
      void sendProgress(int received, int total)?,
      dynamic body,
      bool loading = false,
      CancelToken? cancelToken}) async {
    try {
      final File file = File(filePath);
      if (file.existsSync()) {
        final String fileName = Helpers.baseName(file.path);
        final FormData data = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        });
        if (body != null) {
          data.fields.addAll(body);
        }
        final Response response = await dio.post(apiEndPoint,
            data: data, onSendProgress: sendProgress, cancelToken: cancelToken);
        throwIfNoSuccess(response);
        return response;
      } else {
        throw AppHttpException("File does not exist on your phone !");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<Response> uploadBytes(
      {required String apiEndPoint,
      required Uint8List bytes,
      void sendProgress(int received, int total)?,
      dynamic body,
      bool loading = false,
      CancelToken? cancelToken}) async {
    try {
      final FormData data = FormData.fromMap({
        "file": await MultipartFile.fromBytes(bytes, filename: "xxx.png"),
      });
      if (body != null) {
        data.fields.addAll(body);
      }
      final Response response = await dio.post(apiEndPoint,
          data: data, onSendProgress: sendProgress, cancelToken: cancelToken);
      throwIfNoSuccess(response);
      return response;
    } catch (err) {
      rethrow;
    }
  }

  Future<Response> send(
      {required String reqMethod,
      required String path,
      Function(int count, int total)? onSendProgress,
      Function(int count, int total)? onReceiveProgress,
      CancelToken? cancelToken,
      Map<String, dynamic> body = const <String, dynamic>{},
      Map<String, dynamic> query = const <String, dynamic>{},
      String? saveDirPath}) async {
    late Response res;

    final _body = {}..addAll(body);
    final _query = {}..addAll(query);

    try {
      switch (reqMethod.toUpperCase()) {
        case 'GET':
          res = await dio.get(
            path,
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;
        case 'POST':
          res = await dio.post(
            path,
            data: _body.cast(),
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;
        case 'PUT':
          res = await dio.put(
            path,
            data: _body.cast(),
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;
        case 'PATCH':
          res = await dio.patch(
            path,
            data: _body.cast(),
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;
        case 'DELETE':
          res = await dio.delete(
            path,
            data: _body.cast(),
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;

        case 'DOWNLOAD':
          res = await dio.download(
            path,
            saveDirPath,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
            queryParameters: _query.cast(),
          );

          break;
        default:
          throw ("reqMethod Not available !");
      }

      throwIfNoSuccess(res);

      return res;
    } on DioError catch (err) {
      if (err.type == DioErrorType.other ||
          err.type == DioErrorType.connectTimeout ||
          err.type == DioErrorType.receiveTimeout) {
        throw AppHttpException("Check your internet connection and try again ");
      } else {
        throw AppHttpException(res.data.toString());
      }
    } catch (err) {
      rethrow;
    } finally {
      dio.close();
    }
  }

  void throwIfNoSuccess(Response response) {
    if (response.statusCode! > 300) {
      final errorMsg = response.data['data'].toString();
      throw AppHttpException(errorMsg);
    }
  }

  Future<Response> download(
      {required String path,
      void sendProgress(int received, int total)?,
      required String filePath,
      CancelToken? cancelToken}) async {
    final res = await dio.download(
      path,
      filePath,
      cancelToken: cancelToken,
      onReceiveProgress: sendProgress,
    );
    return res;
  }
}
