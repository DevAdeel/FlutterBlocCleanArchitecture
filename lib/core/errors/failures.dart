import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  const Failures([List properties = const <dynamic>[]]) : super();
}

// General Failures
class ServerFailure extends Failures {
  @override
  List<Object?> get props => [props];
}

class CacheFailure extends Failures {
  @override
  List<Object?> get props => [props];
}
