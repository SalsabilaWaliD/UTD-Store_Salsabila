import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class CryptoRemoteDataSource {
  Stream<double> getBitcoinPriceStream();
  void dispose();
}

class CryptoRemoteDataSourceImpl implements CryptoRemoteDataSource {
  WebSocketChannel? _channel;

  @override
  Stream<double> getBitcoinPriceStream() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
    );

    return _channel!.stream.map((event) {
      final Map<String, dynamic> data = jsonDecode(event as String);
      final String priceStr = data['bitcoin'] ?? '0';
      return double.tryParse(priceStr) ?? 0.0;
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
  }
}
