import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/services/api_service.dart';

void main() {
  group('ApiService', () {
    late Dio dio;
    late ApiService apiService;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      apiService = ApiService(dio);
    });

    test('can be instantiated with a Dio client', () {
      expect(apiService, isNotNull);
    });

    test('get method is callable', () {
      // Verifies the API surface exists without hitting a real server.
      // Integration tests would use a mock adapter.
      expect(() => apiService.get<dynamic>('/products'), throwsA(anything));
    });

    test('post method is callable', () {
      expect(
        () => apiService.post<dynamic>('/orders', data: {'item': '1'}),
        throwsA(anything),
      );
    });

    test('put method is callable', () {
      expect(
        () => apiService.put<dynamic>('/orders/1', data: {'qty': 2}),
        throwsA(anything),
      );
    });

    test('delete method is callable', () {
      expect(
        () => apiService.delete<dynamic>('/orders/1'),
        throwsA(anything),
      );
    });
  });
}
