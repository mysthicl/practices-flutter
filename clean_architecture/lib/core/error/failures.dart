import 'package:equatable/equatable.dart';

/// Clase base para todos los fallos de la app
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Fallo al acceder al almacenamiento local
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}