import 'package:Libry/core/utilities/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Name Validator Tests', () {
    test('Valid Name', () {
      expect(Validator.nameValidator("John"), null);
    });
    test('Empty Name', () {
      expect(Validator.nameValidator(""), "This field can't be empty");
    });
    test('Name with numbers', () {
      expect(Validator.nameValidator("John123"), "Name can't contain numbers");
    });
  });

  group('Genre Validator tests', () {
    test('When we enter already existing genre should return error', () {
      List<String> genres = ['Fiction', 'Non-Fiction'];
      expect(
        Validator.genreValidator('Fiction', genres),
        'Genre already exists',
      );
    });
    test(
      'When we enter already existing genre in lowercase should return error',
      () {
        List<String> genres = ['Fiction', 'Non-Fiction'];
        expect(
          Validator.genreValidator('Fiction', genres),
          'Genre already exists',
        );
      },
    );
  });
}
