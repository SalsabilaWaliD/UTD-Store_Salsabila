part of 'crypto_cubit.dart';

abstract class CryptoState extends Equatable {
  const CryptoState();
  @override
  List<Object?> get props => [];
}

class CryptoInitial extends CryptoState {}

class CryptoConnecting extends CryptoState {}

class CryptoPriceUpdated extends CryptoState {
  final double price;
  final bool isCalculating;
  const CryptoPriceUpdated(this.price, [this.isCalculating = false]);
  @override
  List<Object?> get props => [price, isCalculating];
}

class CryptoTaxCalculating extends CryptoState {
  final double currentPrice;
  const CryptoTaxCalculating(this.currentPrice);
  @override
  List<Object?> get props => [currentPrice];
}

class CryptoTaxResult extends CryptoState {
  final double currentPrice;
  final double taxAmount;
  const CryptoTaxResult(this.currentPrice, this.taxAmount);
  @override
  List<Object?> get props => [currentPrice, taxAmount];
}

class CryptoError extends CryptoState {
  final String message;
  const CryptoError(this.message);
  @override
  List<Object?> get props => [message];
}
