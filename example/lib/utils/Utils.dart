
import 'package:flutter/cupertino.dart';

class Utils
{
  static const String dateFormat = "yyyy-MM-dd";

  void unFocus(BuildContext context)
  {
    FocusScope.of(context).unfocus();
  }
}
