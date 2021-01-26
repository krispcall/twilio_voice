import 'package:http/http.dart';

class ResponseApi {

  int code;
  String body;
  String errorMessage;

  ResponseApi(Response response)
  {
    code = response.statusCode;

    if (isSuccessful())
    {
      body = response.body;
      errorMessage = '';
    }
    else
    {
      body = null;
      errorMessage = response.body;
    }
  }

  bool isSuccessful()
  {
    return code >= 200 && code < 300;
  }
}
