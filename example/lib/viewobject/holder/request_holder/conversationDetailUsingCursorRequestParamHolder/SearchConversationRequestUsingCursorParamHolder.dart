import 'package:voice_example/viewobject/common/Holder.dart';

class SearchConversationUsingCursorRequestParamHolder
    extends Holder<SearchConversationUsingCursorRequestParamHolder> {
  final int last;
  final String beforeWith;

  SearchConversationUsingCursorRequestParamHolder({this.last, this.beforeWith});

  @override
  SearchConversationUsingCursorRequestParamHolder fromMap(dynamicData) {
    return SearchConversationUsingCursorRequestParamHolder(
      last: dynamicData['last'],
      beforeWith: dynamicData["beforeWith"]);

  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (last != null) {
      map['last'] = last;
    }
    if (beforeWith != null) {
      map['beforeWith'] = beforeWith;
    }
    return map;
  }
}

