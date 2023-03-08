import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia_usecase.dart';
import '../../domain/usecases/get_random_number_trivia_usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid input - Number must be positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUsecase getConcreteNumberTrivia;
  final GetRandomNumberTriviaUsecase getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onEventGetConcreteTrivia);
    on<GetTriviaForRandomNumber>(_onEventGetRandomTrivia);
  }

  FutureOr<void> _onEventGetConcreteTrivia(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    final validNumber = _numberOrFailure(event.numberString);
    if (validNumber == null) {
      emit(const Error(message: invalidInputFailureMessage));
      return;
    }
    emit(Loading());
    final failureOrTrivia =
        await getConcreteNumberTrivia(Params(number: validNumber));
    final emitState = _eitherLoadedOrErrorState2(failureOrTrivia);
    emit(emitState);
  }

  FutureOr<void> _onEventGetRandomTrivia(
      GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    final emitState = _eitherLoadedOrErrorState2(failureOrTrivia);
    emit(emitState);
  }

  int? _numberOrFailure(String number) {
    final numberEither = inputConverter.stringToUnsignedInteger(number);
    return numberEither.fold((l) => null, (r) => r);
  }

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final numberEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      yield* numberEither.fold((l) async* {
        yield (const Error(message: invalidInputFailureMessage));
      }, (r) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: r));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  NumberTriviaState _eitherLoadedOrErrorState2(
      Either<Failures, NumberTrivia> failureOrTrivia) {
    return failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (r) => Loaded(trivia: r),
    );
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failures, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (r) => Loaded(trivia: r),
    );
  }

  String _mapFailureToMessage(Failures failures) {
    switch (failures.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
