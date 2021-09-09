
import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';

class WorkspaceSwitchParameterHolder extends Holder<WorkspaceSwitchParameterHolder>
{
  WorkspaceSwitchParameterHolder({
    @required this.defaultWorkspace,
  });

  final String defaultWorkspace;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['defaultWorkspace'] = this.defaultWorkspace;
    return map;
  }

  @override
  WorkspaceSwitchParameterHolder fromMap(dynamic dynamicData) {
    return WorkspaceSwitchParameterHolder(
      defaultWorkspace: dynamicData['defaultWorkspace'],
    );
  }
}