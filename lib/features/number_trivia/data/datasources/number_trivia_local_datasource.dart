import 'dart:convert';

import 'package:bloc_clean_architecture/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cached [NumberTriviaModel] which was fetched last time
  /// the user had an internet connection
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel);
}

const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences preferences;

  NumberTriviaLocalDatasourceImpl(this.preferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel) {
    return preferences.setString(
      CACHED_NUMBER_TRIVIA,
      jsonEncode(triviaModel.toJson()),
    );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = preferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      final model = NumberTriviaModel.fromJson(jsonDecode(jsonString));
      return Future(() => model);
    } else {
      throw CacheException();
    }
  }
}
