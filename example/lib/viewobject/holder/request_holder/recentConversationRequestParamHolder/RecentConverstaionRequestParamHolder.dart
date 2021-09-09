import 'package:voice_example/viewobject/common/Holder.dart';
import 'package:voice_example/viewobject/holder/request_holder/callLogsRequestParamHolder/SearchInputRequestParamHolder.dart';

class RecentConversationRequestParamHolder extends Holder<RecentConversationRequestParamHolder>
{
  final String sort;
  final String conversationType;
  final int first;
  final String before;
  final String after;
  final String afterWith;
  final SearchInputRequestParamHolder search;

  RecentConversationRequestParamHolder({
    this.before,
    this.after,
    this.conversationType,
    this.sort,
    this.first,
    this.afterWith,
    this.search,
  });

  @override
  RecentConversationRequestParamHolder fromMap(dynamicData)
  {
    return RecentConversationRequestParamHolder(
      conversationType: dynamicData['q'],
      first: dynamicData['first'],
      after: dynamicData['after'],
      before: dynamicData['before'],
      afterWith: dynamicData['afterWith'],
      search: SearchInputRequestParamHolder().fromMap(dynamicData['search']),
    );
  }

  @override
  Map toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['q'] = conversationType;

    if (first != null)
    {
      map['first'] = first;
    }
    if (after != null)
    {
      map['after'] = after;
    }
    if (before != null)
    {
      map['before'] = before;
    }
    if (afterWith != null)
    {
      map['afterWith'] = afterWith;
    }
    if(search!=null)
    {
      map['search'] = search.toMap();
    }
    return map;
  }
}
