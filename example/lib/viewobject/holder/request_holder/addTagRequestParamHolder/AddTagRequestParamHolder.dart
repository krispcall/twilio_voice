import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';

class AddTagRequestParamHolder extends Holder<AddTagRequestParamHolder> {
  AddTagRequestParamHolder({
    @required this.title,
    @required this.colorCode,
    @required this.backgroundColorCode,
  });

  String title;
  String colorCode;
  String backgroundColorCode;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['title'] = title;
    map['colorCode'] = colorCode;
    map['backgroundColorCode'] = backgroundColorCode;
    return map;
  }

  @override
  AddTagRequestParamHolder fromMap(dynamic dynamicData)
  {
    return AddTagRequestParamHolder(
      title: dynamicData['title'],
      colorCode: dynamicData['colorCode'],
      backgroundColorCode: dynamicData['backgroundColorCode'],
    );
  }
}
