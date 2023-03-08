import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  /// Calls the
  /// <a href=http://numbersapi.com/43?json>
  ///   <i style=color:yellow>http://numbersapi.com/{number}</i>
  /// </a> endpoint.
  ///
  ///  Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the
  /// <a href=http://numbersapi.com/random?json>
  ///   <i style=color:yellow>http://numbersapi.com/random</i>
  /// </a> endpoint.
  ///
  ///  Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDatasource {
  final http.Client client;

  NumberTriviaRemoteDatasourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getTriviaFromURL(
      url: 'http://numbersapi.com/$number',
    );
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromURL(
      url: 'http://numbersapi.com/random',
    );
  }

  Future<NumberTriviaModel> _getTriviaFromURL({required String url}) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
