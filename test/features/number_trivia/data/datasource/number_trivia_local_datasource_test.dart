import 'package:bloc_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'number_trivia_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDatasourceImpl datasource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDatasourceImpl(mockSharedPreferences);
  });
}
