import 'package:easy_localization/easy_localization.dart';

extension StringExtension on String {
  ///check is email is valid or not
  bool get checkIsValidEmail {
    // var emailReg = RegExp("^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)\$");
    var emailReg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    bool emailValid = emailReg.hasMatch(this);
    return emailValid;
  }


  bool get checkIsFirstLetterUpperCase {
    var nameReg = RegExp(r"^[A-Z][a-zA-Z]{3,}(?: [A-Z][a-zA-Z]*){0,2}$");
    bool  nameValid = nameReg.hasMatch(this);
    return nameValid;
  }


  ///checks at least one Uppercase and Special character
  bool get checkAtLeastUppercaseSpecial {
    var password =
        RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{6,32}\$');
    return password.hasMatch(this);
  }

  ///checks at least one Number, Uppercase and Special character
  bool get checkAtLeastUppercaseSpecialNumber {
    ///Contains digits, uppercase and special char
    var reg = RegExp(
        '^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,32}\$'); //if need digit
    return reg.hasMatch(this);
  }

  ///check password length is valid or not
  bool get checkPasswordLengthIsValid {
    bool isValid = true;
    if (this.length > 46 || this.length < 6) {
      isValid = false;
    }
    return isValid;
  }

  ///check valid Phone Numbers
  bool get isValidatePhoneNumbers {
    if (this != null && this.isNotEmpty) {
      RegExp regExp = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
      return regExp.hasMatch(this);
    } else {
      return false;
    }
  }

  ///check valid Alphabetic only
  bool get checkIsAlphabetic {
    var reg = RegExp('[A-Za-z]+\$'); //if need digit
    return reg.hasMatch(this);
  }

  /// -------------------------------*/
  String get firstLetterToUpperCase {
    if (this != null)
      return this[0].toUpperCase() + this.substring(1);
    else
      return null;
  }

  String get utcTOLocalTimeHour {
    if (this != null) {
      String date = "";
      try {
        var dateFormat = DateFormat("hh:mm a");
        String createdDate =
            dateFormat.format(DateTime.parse(this + 'Z').toLocal());
        date = createdDate;
      } on Exception catch (_) {}
      return date;
    } else {
      return null;
    }
  }

  String get utcTOLocalTimeDate {
    if (this != null) {
      String date = "";
      try {
        var dateFormat = DateFormat("yyyy-MM-ddThh:mm a");
        String createdDate =
            dateFormat.format(DateTime.parse(this + 'Z').toLocal());
        date = createdDate;
        return date;
      } on Exception catch (_) {}
      return date;
    } else {
      return null;
    }
  }

  int parseInt() {
    return int.parse(this);
  }

  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.firstLetterToUpperCase).join(" ");
}
