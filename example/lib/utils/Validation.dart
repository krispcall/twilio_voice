import 'package:voice_example/viewobject/model/country/CountryCode.dart';
import 'package:phone_number/phone_number.dart';

import 'Utils.dart';
import 'extension.dart';

///Login Validation
class LoginValidation {
  static String emailPasswordValidation(String email, String password) {
    var emailReg = RegExp("^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)\$");
    String isValid = "";
    if (email.isEmpty) {
      isValid = Utils.getString('pleaseInputEmail');
    } else if (password.isEmpty) {
      isValid = Utils.getString('pleaseInputPassword');
    } else if (!emailReg.hasMatch(email)) {
      isValid = Utils.getString('pleaseInputValidEmail');
    } else if (email.trim().length > 46) {
      isValid = Utils.getString('emailLimitError');
    } else if (password.trim().length < 6) {
      isValid = Utils.getString('passwordMinLimitError');
    } else if (password.trim().length > 46) {
      isValid = Utils.getString('passwordMaxLimitError');
    }
    return isValid;
  }
}

///Profile validation
class ProfileValidation {
  static String isValidFirstLastName(String firstName, String lastName) {
    String isValid = "";
    if (firstName.isEmpty) {
      isValid = Utils.getString('pleaseInputFirstName');
    } else if (lastName.isEmpty) {
      isValid = Utils.getString('pleaseInputLastName');
    } else if (firstName.trim().length < 2 || firstName.length > 18) {
      isValid = Utils.getString('firstNameExceed');
    } else if (lastName.trim().length < 2 || lastName.length > 44) {
      isValid = Utils.getString('lastNameExceed');
    } else if (!firstName.checkIsAlphabetic) {
      isValid = Utils.getString('invalidNameFormat');
    } else if (!lastName.checkIsAlphabetic) {
      isValid = Utils.getString('invalidNameFormat');
    }
    return isValid;
  }
}

///Workspace validation
class WorkspaceValidation {
  static String isValidWorkspaceName(String name) {
    String isValid = "";
    if (name.isEmpty) {
      isValid = Utils.getString('workSpaceEmpty');
    } else if (name.trim().length < 2) {
      isValid = Utils.getString('workSpaceNameMinLimitError');
    } else if (name.trim().length > 44) {
      isValid = Utils.getString('workSpaceNameMaxLimitError');
    }
    return isValid;
  }
}

///Add Team validation
class TeamsValidation {
  ///Team Name
  static String isTeamsValidation(String name) {
    String isValid = "";
    if (name.isEmpty) {
      isValid = Utils.getString('teamsEmpty');
    } else if (name.trim().length < 2) {
      isValid = Utils.getString('teamsMinLimitError');
    } else if (name.trim().length > 44) {
      isValid = Utils.getString('teamsMaxLimitError');
    }
    return isValid;
  }

  ///Team description
  static String isValidTeamDescriptionValidation(String des) {
    String isValid = "";
    if (des.trim().length > 200) {
      isValid = Utils.getString('teamsDesExceed');
    }
    return isValid;
  }
}

///Member validation
class MemberValidation {
  ///Email
  static String isValidMemberValidation(String email) {
    String isValid = "";
    if (email.isEmpty) {
      isValid = Utils.getString("invalidEmail");
    } else if (!email.trim().checkIsValidEmail) {
      isValid = Utils.getString('invalidEmail');
    } else if (email.trim().length > 46) {
      isValid = Utils.getString("emailLimitError");
    }
    return isValid;
  }
}

///Tag validation
class TagsValidation {
  ///Email
  static String isValidTagsValidation(String tag) {
    String isValid = "";
    if (tag.isEmpty) {
      isValid = Utils.getString('invalidTagName');
    } else if (tag.trim().length < 2) {
      isValid = Utils.getString('tagsMinLimitError');
    } else if (tag.trim().length > 46) {
      isValid = Utils.getString('tagsMaxLimitError');
    }
    return isValid;
  }
}

class NoteValidation {
  static String isValidNote(String note) {
    String isValid = "";
    if (note.isEmpty) {
      isValid = Utils.getString('invalidNote');
    } else if (note.trim().length < 2) {
      isValid = Utils.getString('noteMinLimitError');
    } else if (note.trim().length > 200) {
      isValid = Utils.getString('noteMaxLimitError');
    }
    return isValid;
  }
}

///Contacts
class ContactValidation {
  ///Email
  ///
  static String isContactValidation(
      String name, String phone, String email, String address) {
    String isValid = "";
    if (name.isEmpty) {
      isValid = Utils.getString('fullNameEmpty');
    } else if (name.length < 2 || name.length > 46) {
      isValid = Utils.getString('contactNameExceed');
    } else if (phone.isEmpty) {
      isValid = Utils.getString('numberEmpty');
    } else if (phone.length < 9 || phone.length > 14) {
      isValid = Utils.getString('numberExceed');
    } else if (!phone.isValidatePhoneNumbers) {
      isValid = Utils.getString('invalidPhoneNumber');
    } else if (email.isNotEmpty) {
      if (!email.checkIsValidEmail) {
        isValid = Utils.getString('pleaseInputValidEmail');
      } else if (address.isNotEmpty) {
        if (address.length < 2 || address.length > 46) {
          isValid = Utils.getString('addressExceed');
        }
      }
    } else if (address.isNotEmpty) {
      if (address.length < 2 || address.length > 46) {
        isValid = Utils.getString('addressExceed');
      } else if (email.isNotEmpty) {
        if (!email.checkIsValidEmail) {
          isValid = Utils.getString('pleaseInputValidEmail');
        }
      }
    }
    return isValid;
  }

  static String isValidPhoneNumber(String phone) {
    String isValid = "";
    if (phone.isEmpty) {
      isValid = Utils.getString('numberEmpty');
    } else if (phone.trim().length < 10) {
      isValid = Utils.getString('numberMinLimitError');
    } else if (phone.trim().length > 14) {
      isValid = Utils.getString('numberMaxLimitError');
    } else if (!phone.trim().isValidatePhoneNumbers) {
      isValid = Utils.getString('invalidPhoneNumber');
    }
    return isValid;
  }

  static String isValidEmail(String email) {
    String isValid = "";
    if (email.isEmpty) {
      isValid = Utils.getString('emailRequired');
    } else if (!email.trim().checkIsValidEmail) {
      isValid = Utils.getString('invalidEmail');
    } else if (email.trim().length > 46) {
      isValid = Utils.getString('emailLimitError');
    }
    return isValid;
  }

  static String isValidAddress(String address) {
    String isValid = "";
    if (address.isEmpty) {
    } else {
      if (address.trim().length < 2) {
        isValid = Utils.getString('addressMinLimitError');
      } else if (address.trim().length > 46) {
        isValid = Utils.getString('addressMaxLimitError');
      }
    }
    return isValid;
  }

  static String isValidCompany(String company) {
    String isValid = "";
    if (company.isEmpty) {
      // isValid = Utils.getString('companyRequired');
    } else {
      if (company.trim().length < 2) {
        isValid = Utils.getString('companyMinLimitError');
      } else if (company.trim().length > 46) {
        isValid = Utils.getString('companyMaxLimitError');
      }
    }

    return isValid;
  }

  static String isValidName(String fullName) {
    String isValid = "";
    if (fullName.isEmpty) {
      isValid = Utils.getString('pleaseInputFirstName');
    } else if (fullName.trim().length < 2) {
      isValid = Utils.getString('fullNameMinLimitError');
    } else if (fullName.trim().length > 46) {
      isValid = Utils.getString('fullNameMaxLimitError');
    }
    return isValid;
  }

  static checkValidPhoneNumber(
      CountryCode selectedCountryCode, String phone) async {
    return await PhoneNumberUtil().validate(
        phone,
        RegionInfo(
                name: selectedCountryCode.name,
                code: selectedCountryCode.code,
                prefix: int.parse(selectedCountryCode.dialCode))
            .code);
  }
}
