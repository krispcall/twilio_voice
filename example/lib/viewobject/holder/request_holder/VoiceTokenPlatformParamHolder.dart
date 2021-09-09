import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart' show Holder;

class VoiceTokenPlatformParamHolder extends Holder<VoiceTokenPlatformParamHolder> {

  VoiceTokenPlatformParamHolder({@required this.platform});

  final String platform;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['platform'] = this.platform;
    return map;
  }

  @override
  VoiceTokenPlatformParamHolder fromMap(dynamic dynamicData) {
    return VoiceTokenPlatformParamHolder(
      platform: dynamicData['platform'],
    );
  }
}
