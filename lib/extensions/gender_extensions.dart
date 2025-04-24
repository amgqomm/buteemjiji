import '../utils/app_enums.dart';

extension GenderExtension on Gender {
  String get translation {
    switch (this) {
      case Gender.male:
        return 'Эр';
      case Gender.female:
        return 'Эм';
      case Gender.other:
        return 'Бусад';
      }
  }

  String get avatar {
    switch (this) {
      case Gender.male:
        return 'assets/images/male.jpg';
      case Gender.female:
        return 'assets/images/female.jpg';
      case Gender.other:
        return 'assets/images/other.jpg';
      }
  }
}
