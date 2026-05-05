import 'dart:async';
import 'dart:isolate';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/crypto_remote_datasource.dart';

part 'crypto_state.dart';

class CryptoCubit extends Cubit<CryptoState> {
  final CryptoRemoteDataSource _cryptoDataSource;
  StreamSubscription? _subscription;

  CryptoCubit(this._cryptoDataSource) : super(CryptoInitial());

  void connectWebSocket() {
    emit(CryptoConnecting());
    _subscription = _cryptoDataSource.getBitcoinPriceStream().listen(
      (price) => emit(CryptoPriceUpdated(price, state is CryptoTaxCalculating)),
      onError: (e) => emit(CryptoError(e.toString())),
    );
  }

  /// Kalkulasi Pajak Kripto menggunakan Isolate (background worker).
  ///
  /// LOGIKA PERSONAL NIM 20123017:
  /// 2 digit terakhir NIM = 17
  /// Isolate melakukan looping penjumlahan sebanyak: 17 × 10.000.000 = 170.000.000 kali
  ///
  /// Syarat lulus: Animasi harga Bitcoin TIDAK BOLEH freeze saat looping berjalan!
  Future<void> calculateCryptoTax(double currentPrice) async {
    final currentPriceVal = currentPrice;

    // Emit state calculating (flag agar UI tahu isolate sedang berjalan)
    emit(CryptoTaxCalculating(currentPriceVal));

    // Jalankan di Isolate terpisah agar UI thread tetap responsif
    final result = await compute(_isolateTaxCalculation, currentPriceVal);

    emit(CryptoTaxResult(currentPriceVal, result));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _cryptoDataSource.dispose();
    return super.close();
  }
}

/// Fungsi ini dijalankan di Isolate terpisah (background).
/// Tidak boleh menggunakan state Cubit di sini.
///
/// Logika: looping 17 × 10.000.000 = 170.000.000 kali
/// NIM: 20123017 → 2 digit terakhir = 17
double _isolateTaxCalculation(double bitcoinPrice) {
  const int nimTwoLastDigits = 17; // dari NIM 20123017
  const int multiplier = 10000000;
  final int totalLoops = nimTwoLastDigits * multiplier; // 170.000.000

  double sum = 0;
  for (int i = 0; i < totalLoops; i++) {
    sum += 1;
  }

  // Hitung pajak kripto: 0.1% dari harga Bitcoin × total loop sebagai simulasi
  const double taxRate = 0.001; // 0.1% pajak kripto
  return bitcoinPrice * taxRate;
}
