import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Contrato base para todos los Use Cases
/// [Type] = tipo de retorno, [Params] = parámetros de entrada
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Usar cuando un Use Case no necesita parámetros
class NoParams {}