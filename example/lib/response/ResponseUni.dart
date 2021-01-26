abstract class ResponseUni<T> {

  String key = '0';

  String getPrimaryKey();

  T fromMap(dynamic dynamicData);

  Map<String, dynamic> toMap(T object);
}
