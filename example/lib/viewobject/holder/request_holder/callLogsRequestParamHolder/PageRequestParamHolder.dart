import 'package:voice_example/viewobject/common/Holder.dart';
import 'package:voice_example/viewobject/holder/request_holder/callLogsRequestParamHolder/SearchInputRequestParamHolder.dart';

class PageRequestParamHolder extends Holder<PageRequestParamHolder>
{
  final String sort;
  final String q;
  final int first;
  final String before;
  final String after;
  final String afterWith;
  final String order;
  final SearchInputRequestParamHolder searchInputRequestParamHolder;

  PageRequestParamHolder({
    this.before,
    this.after,
    this.q,
    this.sort,
    this.first,
    this.afterWith,
    this.order,
    this.searchInputRequestParamHolder,
  });

  @override
  PageRequestParamHolder fromMap(dynamicData) {
    return PageRequestParamHolder(
      q: dynamicData['q'],
      first: dynamicData['first'],
      after: dynamicData['after'],
      before: dynamicData['before'],
      afterWith: dynamicData['afterWith'],
      order: dynamicData['order'],
      searchInputRequestParamHolder: SearchInputRequestParamHolder().fromMap(dynamicData['search']),
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['q'] = q;

    if (first != null) {
      map['first'] = first;
    }
    if (after != null) {
      map['after'] = after;
    }
    if (before != null) {
      map['before'] = before;
    }
    if (afterWith != null) {
      map['afterWith'] = afterWith;
    }
    if(order!=null)
    {
      map['order'] = order;
    }
    if(searchInputRequestParamHolder!=null)
    {
      map['search'] = searchInputRequestParamHolder.toMap();
    }
    return map;
  }
}