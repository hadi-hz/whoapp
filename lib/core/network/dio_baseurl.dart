import 'package:dio/dio.dart';

class DioBase  {

  final Dio dio;

  DioBase()
      : dio = Dio(
          BaseOptions(
            baseUrl: "https://gorgeous-repeatedly-haddock.ngrok-free.app/api",
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              "Content-Type": "application/json",
            },
          ),
        );
}
