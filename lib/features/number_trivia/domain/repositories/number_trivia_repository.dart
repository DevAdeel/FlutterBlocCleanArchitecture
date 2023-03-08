import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  /// Get Trivia for number from datasource
  ///
  /// Throws a [ServerException] for all error codes
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();
}
