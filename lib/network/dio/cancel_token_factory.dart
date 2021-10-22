import 'package:dio/dio.dart';

class CancelTokenFactory {
  CancelToken? _cancelToken;

  static CancelTokenFactory? _factory;

  static CancelTokenFactory getInstance() {
    if (_factory == null) {
      _factory = CancelTokenFactory();
    }
    return _factory!;
  }

  get cancelToken {
    if (_cancelToken == null) {
      _cancelToken = CancelToken();
    }
    return _cancelToken;
  }

  void clear() {
    _cancelToken = null;
  }
}
