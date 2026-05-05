import 'dart:async';
import 'dart:isolate';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/crypto_remote_datasource.dart';

part 'crypto_state.dart';

class CryptoCubit extends Cubit<CryptoState> {
  final CryptoRemoteDataSource _dataSource;
  StreamSubscription? _webSocketSubscription;
  Isolate? _currentIsolate;
  ReceivePort? _receivePort;
  
  double _currentPrice = 0;

  CryptoCubit(this._dataSource) : super(CryptoStateInitial());

  Future<void> connectWebSocket() async {
    emit(CryptoStateLoading());
    
    _webSocketSubscription?.cancel();
    _webSocketSubscription = _dataSource.getBitcoinPriceStream().listen(
      (price) {
        _currentPrice = price;
        emit(CryptoStateLoaded(btcPrice: price, taxPrice: null));
      },
      onError: (e) => emit(CryptoStateError(e.toString())),
    );
  }
  
  Future<void> calculateCryptoTax(double price) async {
    _cleanupIsolate();
    
    try {
      _receivePort = ReceivePort();
      _currentIsolate = await Isolate.spawn(
        _heavyCalculation,
        _IsolateParams(
          price: price,
          iterations: 170000000, // 17 × 10.000.000
          sendPort: _receivePort!.sendPort,
        ),
      );
      
      final result = await _receivePort!.first.timeout(
        Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Kalkulasi terlalu lama'),
      );
      
      emit(CryptoStateLoaded(btcPrice: _currentPrice, taxPrice: result as double));
    } catch (e) {
      emit(CryptoStateError(e.toString()));
    } finally {
      _cleanupIsolate();
    }
  }
  
  void _cleanupIsolate() {
    _receivePort?.close();
    _currentIsolate?.kill(priority: Isolate.immediate);
    _currentIsolate = null;
    _receivePort = null;
  }
  
  static void _heavyCalculation(_IsolateParams params) {
    double result = params.price;
    for (int i = 0; i < params.iterations; i++) {
      result = result * 1.000000001;
    }
    params.sendPort.send(result);
  }
  
  void disconnectWebSocket() {
    _webSocketSubscription?.cancel();
    _cleanupIsolate();
  }
  
  @override
  Future<void> close() {
    disconnectWebSocket();
    return super.close();
  }
}

class _IsolateParams {
  final double price;
  final int iterations;
  final SendPort sendPort;
  
  _IsolateParams({
    required this.price,
    required this.iterations,
    required this.sendPort,
  });
}