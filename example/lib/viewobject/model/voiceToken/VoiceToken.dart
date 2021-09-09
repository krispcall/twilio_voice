import 'package:quiver/core.dart';
import 'package:voice_example/viewobject/common/Object.dart';

class VoiceToken extends Object<VoiceToken> {
  VoiceToken({
    this.voiceToken,
  });

  String voiceToken;

  @override
  bool operator ==(dynamic other) => other is VoiceToken && voiceToken == other.voiceToken;


  @override
  int get hashCode => hash2(voiceToken.hashCode, voiceToken.hashCode);

  @override
  String getPrimaryKey()
  {
    return voiceToken;
  }

  @override
  VoiceToken fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return VoiceToken(
        voiceToken: dynamicData['voiceToken'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['voiceToken'] = object.voiceToken;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<VoiceToken> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<VoiceToken> voiceTokenList = <VoiceToken>[];
    if (dynamicDataList != null)
    {
      for (dynamic json in dynamicDataList)
      {
        if (json != null)
        {
          voiceTokenList.add(fromMap(json));
        }
      }
    }
    return voiceTokenList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<VoiceToken> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (VoiceToken data in objectList)
      {
        if (data != null)
        {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
