

String name_validator(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Name is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

String password_validator(String value) {
  // String patttern = r'(^[a-zA-Z ]*$)';
  // RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Password is Required";
  } else if (value.length < 8) {
    return "Password must be at least 8 character long";
  }
  // else if (!regExp.hasMatch(value)) {
  //   return "Name must be a-z and A-Z";
  // }
  return null;
}

String new_password_validator(String value) {
  // String patttern = r'(^[a-zA-Z ]*$)';
  // RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "New Password is Required";
  } else if (value.length < 8) {
    return "New Password must be at least 8 character long";
  }
  // else if (!regExp.hasMatch(value)) {
  //   return "Name must be a-z and A-Z";
  // }
  return null;
}

String emptyValidator(String value) {
  if (value.length == 0) {
    return "Field must not be empty.";
  }
  return null;
}

String confirm_new_password_validator(String value) {
  // String patttern = r'(^[a-zA-Z ]*$)';
  // RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Confirm New Password is Required";
  } else if (value.length < 8) {
    return "Confirm New Password must be at least 8 character long";
  }
  // else if (!regExp.hasMatch(value)) {
  //   return "Name must be a-z and A-Z";
  // }
  return null;
}


String emailValidator(String value) {
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Field is Required";
  }
  else if (!regExp.hasMatch(value)) {
     return "Invalid Email";
  } else {
    return null;
  }
}

String mobileValidator(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Mobile is Required";
  } else if (value.length != 10) {
    return "Mobile number must 10 digits";
  } else if (!regExp.hasMatch(value)) {
    return "Mobile Number must be digits";
  }
  return null;
}

String emailornumber_validator(String value) {
  if (value.length == 0) {
    return "Field must not be empty.";
  }
  return null;
}

String tenLengthValidator(String value) {
  if (value.length < 10) {
    return "Field is not valid!";
  }
  return null;
}
