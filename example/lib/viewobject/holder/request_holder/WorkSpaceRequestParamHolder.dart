import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';

class WorkSpaceRequestParamHolder extends Holder<WorkSpaceRequestParamHolder> {
  WorkSpaceRequestParamHolder({
    @required this.authToken,
    @required this.workspaceId,
    @required this.memberId
  });

  final String authToken;
  final String workspaceId;
  final String memberId;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['authToken'] = authToken;
    map['workspaceId'] = workspaceId;
    map['memberId'] = memberId;
    return map;
  }

  @override
  WorkSpaceRequestParamHolder fromMap(dynamic dynamicData) {
    return WorkSpaceRequestParamHolder(
      authToken: dynamicData['authToken'],
      workspaceId: dynamicData['workspaceId'],
      memberId: dynamicData['memberId'],
    );
  }
}
