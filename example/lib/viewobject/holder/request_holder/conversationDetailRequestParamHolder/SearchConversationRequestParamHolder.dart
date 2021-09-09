import 'package:voice_example/viewobject/common/Holder.dart';

class SearchConversationRequestParamHolder
    extends Holder<SearchConversationRequestParamHolder> {
  final int first;
  final Search search;

  SearchConversationRequestParamHolder({this.first, this.search});

  @override
  SearchConversationRequestParamHolder fromMap(dynamicData) {
    return SearchConversationRequestParamHolder(
      first: dynamicData['first'],
      search: Search().fromMap(dynamicData["search"]),
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (first != null) {
      map['first'] = first;
    }
    if (search != null) {
      map['search'] = Search(columns: search.columns,value: search.value).toMap();
    }
    return map;
  }
}

class Search extends Holder<Search> {
  final List<String> columns;
  final String value;

  Search({this.columns, this.value});

  @override
  Search fromMap(dynamicData) {
    return Search(
      columns: dynamicData['columns'].cast<String>(),
      value: dynamicData['value'],
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (columns != null) {
      map['columns'] = columns;
    }
    if (value != null) {
      map['value'] = value;
    }
    return map;
  }
}
