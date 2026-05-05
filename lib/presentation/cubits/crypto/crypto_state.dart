part of 'crypto_cubit.dart';

abstract class CryptoState extends Equatable {}

class CryptoStateInitial extends CryptoState {
  @override
  List<Object?> get props => [];
}

class CryptoStateLoading extends CryptoState {
  @override
  List<Object?> get props => [];
}

class CryptoStateLoaded extends CryptoState {
  final double btcPrice;
  final double? taxPrice;
  
  CryptoStateLoaded({required this.btcPrice, this.taxPrice});
  
  @override
  List<Object?> get props => [btcPrice, taxPrice];
}

class CryptoStateError extends CryptoState {
  final String message;
  
  CryptoStateError(this.message);
  
  @override
  List<Object?> get props => [message];
}