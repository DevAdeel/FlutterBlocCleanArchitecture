import 'package:bloc_clean_architecture/core/usecases/usecase.dart';
import 'package:bloc_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:bloc_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  late MockNumberTriviaRepository repository;
  late GetRandomNumberTriviaUsecase usecase;

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTriviaUsecase(repository);
  });

  const tNumberTrivia = NumberTrivia(text: "Test Random Trivia", number: 1);

  test("should return trivia for random number", () async {
    when(repository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));

    final result = await usecase(NoParams());

    expect(result, const Right(tNumberTrivia));
    verify(repository.getRandomNumberTrivia());
    verifyNoMoreInteractions(repository);
  });
}
