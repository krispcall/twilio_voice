
import 'package:voice_example/enum/StatusEnum.dart';

class ResponseFormat<T>
{
  ResponseFormat(this.status, this.message, this.value);

  final Status status;

  final String message;

  T value;
}
