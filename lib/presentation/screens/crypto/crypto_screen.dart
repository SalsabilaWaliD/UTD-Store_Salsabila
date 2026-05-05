import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/crypto/crypto_cubit.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  // MethodChannel untuk Native Integration (Platform Channel)
  static const _channel = MethodChannel('com.utdstore.salsabila/native');

  int? _batteryLevel;
  bool _isLoadingBattery = false;

  /// Membaca persentase baterai via MethodChannel (memanggil kode Kotlin native)
  Future<void> _getBatteryLevel() async {
    setState(() => _isLoadingBattery = true);
    try {
      final int battery = await _channel.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryLevel = battery;
        _isLoadingBattery = false;
      });
    } on PlatformException catch (e) {
      setState(() => _isLoadingBattery = false);
      debugPrint('Error getting battery: ${e.message}');
    }
  }

  /// Memunculkan Native Toast Android via MethodChannel
  Future<void> _showNativeToast(String message) async {
    try {
      await _channel.invokeMethod('showToast', {'message': message});
    } on PlatformException catch (e) {
      debugPrint('Error showing toast: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crypto Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CryptoCubit, CryptoState>(
        listener: (context, state) {
          if (state is CryptoTaxResult) {
            _showNativeToast(
              'Pajak: \$${state.taxAmount.toStringAsFixed(2)}',
            );
          }
        },
        builder: (context, state) {
          double? currentPrice;
          bool isCalculating = false;

          if (state is CryptoPriceUpdated) {
            currentPrice = state.price;
            isCalculating = state.isCalculating;
          } else if (state is CryptoTaxCalculating) {
            currentPrice = state.currentPrice;
            isCalculating = true;
          } else if (state is CryptoTaxResult) {
            currentPrice = state.currentPrice;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ── Bitcoin Price Card ──────────────────────
                _BitcoinPriceCard(
                  price: currentPrice,
                  isConnecting: state is CryptoConnecting,
                ),
                const SizedBox(height: 20),

                // ── Tax Calculator ──────────────────────────
                _TaxCard(
                  state: state,
                  isCalculating: isCalculating,
                  onCalculate: () {
                    if (currentPrice != null && !isCalculating) {
                      context.read<CryptoCubit>().calculateCryptoTax(currentPrice);
                    }
                  },
                ),
                const SizedBox(height: 20),

                // ── Native Battery ──────────────────────────
                _BatteryCard(
                  batteryLevel: _batteryLevel,
                  isLoading: _isLoadingBattery,
                  onGetBattery: _getBatteryLevel,
                  onShowToast: () => _showNativeToast('UTD Store - Salsabila 20123017'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BitcoinPriceCard extends StatelessWidget {
  final double? price;
  final bool isConnecting;

  const _BitcoinPriceCard({this.price, required this.isConnecting});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7931A), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.currency_bitcoin, color: Colors.white, size: 32),
              const SizedBox(width: 8),
              const Text(
                'Bitcoin (BTC)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              if (isConnecting)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.greenAccent),
                      SizedBox(width: 4),
                      Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (price != null)
            Text(
              '\$${price!.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            )
          else
            const Text(
              'Menghubungkan...',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          const SizedBox(height: 8),
          const Text(
            'WebSocket: wss://ws.coincap.io',
            style: TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _TaxCard extends StatelessWidget {
  final CryptoState state;
  final bool isCalculating;
  final VoidCallback onCalculate;

  const _TaxCard({
    required this.state,
    required this.isCalculating,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calculate, color: Color(0xFF1A237E)),
              SizedBox(width: 8),
              Text(
                'Kalkulasi Pajak Kripto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            // Penjelasan logika NIM untuk dokumentasi
            'Isolate melakukan 17 × 10.000.000 = 170.000.000 iterasi\n'
            '(2 digit terakhir NIM 20123017 = 17)',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          if (state is CryptoTaxResult)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kalkulasi selesai!',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Estimasi Pajak: \$${(state as CryptoTaxResult).taxAmount.toStringAsFixed(4)}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isCalculating ? null : onCalculate,
              icon: isCalculating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(isCalculating ? 'Menghitung di Isolate...' : 'Kalkulasi Pajak Kripto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BatteryCard extends StatelessWidget {
  final int? batteryLevel;
  final bool isLoading;
  final VoidCallback onGetBattery;
  final VoidCallback onShowToast;

  const _BatteryCard({
    this.batteryLevel,
    required this.isLoading,
    required this.onGetBattery,
    required this.onShowToast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.smartphone, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Native Platform Channel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Menggunakan MethodChannel untuk akses hardware native (Kotlin)',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          if (batteryLevel != null) ...[
            Row(
              children: [
                Icon(
                  batteryLevel! > 20 ? Icons.battery_full : Icons.battery_alert,
                  color: batteryLevel! > 20 ? Colors.green : Colors.red,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sisa Baterai', style: TextStyle(color: Colors.grey)),
                    Text(
                      '$batteryLevel%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : onGetBattery,
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.battery_charging_full),
                  label: const Text('Cek Baterai'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onShowToast,
                  icon: const Icon(Icons.notifications),
                  label: const Text('Native Toast'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
