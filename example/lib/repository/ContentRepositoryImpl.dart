import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:voice_example/enum/StatusEnum.dart';
import 'package:voice_example/response/ResponseApi.dart';
import 'package:voice_example/response/ResponseCallAccessToken.dart';
import 'package:voice_example/response/ResponseFormat.dart';
import 'package:voice_example/response/ResponseLogin.dart';
import 'package:voice_example/response/ResponseUni.dart';
import 'ContentRepository.dart';
import 'SecureStorageRepositoryImpl.dart';


class ContentRepositoryImpl extends ContentRepository
{

  static String liveUrl="http://128.199.75.138/api/";

  @override
  Future<ConnectivityResult> checkConnection() async
  {
    return Connectivity().checkConnectivity();
  }

  @override
  Future<ResponseFormat<R>> doApiGetCall<T extends ResponseUni, R>(T obj, String url) async
  {
    SecureStorageRepositoryImpl secureStorageRepositoryImpl = SecureStorageRepositoryImpl();
    String apiToken = await secureStorageRepositoryImpl.getApiToken();
    if (apiToken == null)
    {
      apiToken="";
    }
    final Client client = http.Client();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/x-www-form-urlencoded',
      'Authorization':apiToken
    };
    try
    {
      final Response response = await client.get(
          url,
          headers: requestHeaders
      );
      final ResponseApi psApiResponse = ResponseApi(response);

      print(response.body.toString());
      print(requestHeaders.toString());
      print(response.request.toString());

      if (psApiResponse.isSuccessful())
      {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map))
        {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data)
          {
            tList.add(obj.fromMap(data as dynamic));
          });
          return ResponseFormat<R>(Status.SUCCESS, '', tList ?? R);
        }
        else
        {
          return ResponseFormat<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      }
      else
      {
        return ResponseFormat<R>(Status.ERROR, psApiResponse.errorMessage, null);
      }
    }
    finally
    {
      client.close();
    }
  }

  @override
  Future<ResponseFormat<R>> doApiPostCall<T extends ResponseUni, R>(T obj, String url, Map<String, dynamic> map) async
  {
    SecureStorageRepositoryImpl secureStorageRepositoryImpl = SecureStorageRepositoryImpl();
    String apiToken = await secureStorageRepositoryImpl.getApiToken();
    if (apiToken == null)
      {
        apiToken="";
      }
    Map valueMap = json.decode(JsonEncoder().convert(map));
    final Client client = http.Client();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/x-www-form-urlencoded',
      'Authorization':'Bearer '+apiToken
    };
    try
    {
      final response = await http.post(
        '$url',
        headers: requestHeaders,
        body: valueMap,
      ).catchError((dynamic e)
      {
        print("${e.toString()}");
      });

      print(response.body);

      final ResponseApi psApiResponse = ResponseApi(response);

      if (psApiResponse.isSuccessful())
      {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map))
        {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data)
          {
            tList.add(obj.fromMap(data));
          });
          return ResponseFormat<R>(Status.SUCCESS, '', tList ?? R);
        }
        else
        {
          return ResponseFormat<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      }
      else
      {
        return ResponseFormat<R>(Status.ERROR, psApiResponse.errorMessage, null);
      }
    }
    finally
    {
      client.close();
    }
  }

  @override
  Future<ResponseFormat<ResponseLogin>> doLoginApiCall(Map<String, dynamic> map) async
  {
    final String url = liveUrl+"token";
    return await doApiPostCall<ResponseLogin, ResponseLogin>(ResponseLogin(), url, map);
  }

  @override
  Future<ResponseFormat<ResponseCallAccessMobileToken>> doCallAccessMobileTokenApiCall() async
  {
    final String url = liveUrl+"call_access_token_mobile";
    return await doApiGetCall<ResponseCallAccessMobileToken, ResponseCallAccessMobileToken>(ResponseCallAccessMobileToken(), url);
  }
}
