import 'package:voice_example/viewobject/common/Holder.dart';

class AllContactRequestParamHolder
    extends Holder<AllContactRequestParamHolder> {
  final String sort;
  final String conversationType;
  final int first;
  final String before;
  final String after;
  final String afterWith;
  final String order;

  AllContactRequestParamHolder({
    this.before,
    this.after,
    this.conversationType,
    this.sort,
    this.first,
    this.afterWith,
    this.order,
  });

  @override
  AllContactRequestParamHolder fromMap(dynamicData) {
    return AllContactRequestParamHolder(
      conversationType: dynamicData['q'],
      first: dynamicData['first'],
      after: dynamicData['after'],
      before: dynamicData['before'],
      afterWith: dynamicData['afterWith'],
      order: dynamicData['order'],
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    if (conversationType != null) {
      map['q'] = conversationType;
    }

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
    if (order != null) {
      map['order'] = order;
    }
    return map;
  }
}
