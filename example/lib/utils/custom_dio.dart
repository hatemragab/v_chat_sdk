import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'config.dart';

class CustomDio {
  late Dio dio;

  CustomDio() {
    dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.validateStatus = (_) => true;
    dio.options.headers = {
      'authorization': GetStorage().read("myModel")==null?"":GetStorage().read("myModel")['authToken']
    };
    dio.options.sendTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.options.connectTimeout = 10000;
  }

  // notes
  // onSendProgress onReceiveProgress cancelToken and Download Will have another video to explain

  Future<Response> send(
      {required String reqMethod,
      required String path,
      Function(int count, int total)? onSendProgress,
      Function(int count, int total)? onReceiveProgress,
      CancelToken? cancelToken,
      Map<String, dynamic>? body,
      Map<String, dynamic>? query}) async {
    late Response res;

    try {
      switch (reqMethod.toUpperCase()) {
        case 'GET':
          res = await dio.get(
            path,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        case 'POST':
          res = await dio.post(
            path,
            data: body,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        case 'PUT':
          res = await dio.put(
            path,
            data: body,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        case 'PATCH':
          res = await dio.patch(
            path,
            data: body,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        case 'DELETE':
          res = await dio.delete(
            path,
            data: body,
            cancelToken: cancelToken,
            queryParameters: query,
          );
          break;
        default:
          throw UnimplementedError();
      }
      throwIfNoSuccess(res);
      return res;
    } on DioError catch (err) {
      if (err.type == DioErrorType.other ||
          err.type == DioErrorType.connectTimeout ||
          err.type == DioErrorType.receiveTimeout) {
        print(err);
        rethrow;
        throw ("you don't have intent connection or server down");
      } else {
        throw (res.data.toString());
      }
    } catch (err) {
      rethrow;
    } finally {
      dio.close();
    }
  }

  Future<Response> uploadFiles(
      {required String apiEndPoint,
      required List<DioUploadFileModel> filesModel,
      void sendProgress(int received, int total)?,
      List<Map<String, String>>? body,
      CancelToken? cancelToken}) async {
    final mapOfData = <String, dynamic>{};
    for (final file in filesModel) {
      final _file = File(file.filePath);
      final fileName = basename(_file.path);
      mapOfData.addAll({
        file.fileFiledName: await MultipartFile.fromFile(
          _file.path,
          filename: fileName,
        ),
      });
    }
    final formData = FormData.fromMap(mapOfData);

    if (body != null) {
      final x = body.map((e) => MapEntry(e.keys.first, e.values.first));
      formData.fields.addAll(x);
    }
    final Response response = await dio.post(apiEndPoint,
        data: formData, onSendProgress: sendProgress, cancelToken: cancelToken);
    throwIfNoSuccess(response);
    return response;
  }

  Future<Response> uploadFile(
      {required String apiEndPoint,
      required String filePath,
      void sendProgress(int received, int total)?,
      List<Map<String, String>>? body,
      CancelToken? cancelToken}) async {
    final File file = File(filePath);
    final String fileName = basename(file.path);
    final FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    if (body != null) {
      final x = body.map((e) => MapEntry(e.keys.first, e.values.first));
      data.fields.addAll(x);
    }
    final Response response = await dio.post(apiEndPoint,
        data: data, onSendProgress: sendProgress, cancelToken: cancelToken);
    throwIfNoSuccess(response);
    return response;
  }

  Future<Response> uploadBytes(
      {required String apiEndPoint,
      required Uint8List bytes,
      required String bytesExtension,
      void sendProgress(int received, int total)?,
      List<Map<String, String>>? body,
      CancelToken? cancelToken}) async {
    //if the file is image then app .png
    final FormData data = FormData.fromMap({
      "file": MultipartFile.fromBytes(bytes, filename: "xxx.$bytesExtension"),
    });
    if (body != null) {
      final x = body.map((e) => MapEntry(e.keys.first, e.values.first));
      data.fields.addAll(x);
    }
    final Response response = await dio.post(apiEndPoint,
        data: data, onSendProgress: sendProgress, cancelToken: cancelToken);
    throwIfNoSuccess(response);
    return response;
  }

  void throwIfNoSuccess(Response response) {
    if (response.statusCode! > 300) {
      final errorMsg = response.data.toString();
      throw (errorMsg);
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

class DioUploadFileModel {
  final String filePath;
  final String fileFiledName;

  const DioUploadFileModel(
      {required this.filePath, required this.fileFiledName});
}
