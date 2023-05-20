import 'package:fpdart/fpdart.dart';
import 'package:motiv8_ai/api/auth_api.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
