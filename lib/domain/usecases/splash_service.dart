/// SplashService berada di layer Domain/Service.
/// Logika delay berdasarkan NIM Salsabila: 20123017
/// Digit terakhir NIM = 7  →  delay = 7 detik
class SplashService {
  final int delaySeconds;

  const SplashService({required this.delaySeconds});

  /// Melakukan delay sesuai digit terakhir NIM.
  /// Dipanggil dari Splash Screen, bukan diatur di UI langsung.
  Future<void> performSplashDelay() async {
    await Future.delayed(Duration(seconds: delaySeconds));
  }
}
