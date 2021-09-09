import 'dart:convert';
import 'package:graphql/client.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/constant/Constants.dart';
import 'package:voice_example/db/common/ps_shared_preferences.dart';
import 'package:voice_example/graph_ql/GraphQLConfiguration.dart';
import 'package:voice_example/provider/user/UserProvider.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'Resources.dart';
import 'dart:async';
import 'package:voice_example/api/common/Resources.dart';

abstract class Api {
  Future<Resources<R>>
      doServerCallQueryWithoutAuth<T extends Object<dynamic>, R>(
          T obj, String query) async {

    GraphQLClient _client = GraphQLConfiguration().clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(query),
        pollInterval: Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    );

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return Resources<R>(Status.SUCCESS, '', tList ?? R);
        } else {
          return Resources<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return Resources<R>(Status.ERROR, "", obj.fromMap(result.data));
      }
    } else {
      return errorHandling(result);
    }
  }

  Future<Resources<R>> doServerCallQueryWithAuth<T extends Object<dynamic>, R>(
      T obj, String document) async {
    GraphQLClient _client = GraphQLConfiguration().clientToQueryWithToken(
        PsSharedPreferences.instance.shared
            .getString(Const.VALUE_HOLDER_API_TOKEN));

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(document),
        pollInterval: Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    );

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return Resources<R>(Status.SUCCESS, '', tList ?? R);
        } else {
          return Resources<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return Resources<R>(Status.ERROR, "", obj.fromMap(result.data));
      }
    } else {
      return errorHandling(result);
    }
  }

  Future<Resources<R>> doServerCallQueryWithCallAccessToken<T extends Object<dynamic>, R>(T obj, String document) async
  {
    GraphQLClient _client = GraphQLConfiguration().clientToQueryWithToken(PsSharedPreferences.instance.shared.getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN));

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(document),
        pollInterval: Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    );

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return Resources<R>(Status.SUCCESS, '', tList ?? R);
        } else {
          return Resources<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return Resources<R>(Status.ERROR, "", obj.fromMap(result.data));
      }
    } else {
      return errorHandling(result);
    }
  }

  Future<Resources<R>> doServerCallQueryWithAuthQueryAndVariable<T extends Object<dynamic>, R>(T obj, String document, Map<String, dynamic> variable) async
  {
    GraphQLClient _client = GraphQLConfiguration().clientToQueryWithToken(PsSharedPreferences.instance.shared.getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN));
    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(document),
        variables: variable,
        pollInterval: Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    );

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return Resources<R>(Status.SUCCESS, '', tList ?? R);
        } else {
          return Resources<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return Resources<R>(Status.ERROR, "", obj.fromMap(result.data));
      }
    } else {
      return errorHandling(result);
    }
  }

  Future<Resources<R>> doServerCallMutationWithoutAuth<T extends Object<dynamic>, R>(T obj, Map<dynamic, dynamic> jsonMap, String mutate) async
  {
    QueryResult result = await GraphQLConfiguration().clientToQuery().mutate(
          MutationOptions(
            document: gql(mutate),
            variables: jsonMap,
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.all,
          ),
        );

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return Resources<R>(Status.SUCCESS, '', tList ?? R);
        } else {
          return Resources<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return Resources<R>(Status.ERROR, "", obj.fromMap(result.data));
      }
    } else {
      return errorHandling(result);
    }
  }

  Future<Resources<R>> doServerCallMutationWithApiAuth<T extends Object<dynamic>, R>(T obj, Map<String, dynamic> jsonMap, String mutate) async
  {
    QueryResult result = await GraphQLConfiguration()
        .clientToQueryWithToken(PsSharedPreferences.instance.shared.getString(Const.VALUE_HOLDER_API_TOKEN))
        .mutate(MutationOptions(
          document: gql(mutate),
          variables: jsonMap,
          fetchPolicy: FetchPolicy.networkOnly,
          errorPolicy: ErrorPolicy.all,
        ));

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return Resources<R>(Status.SUCCESS, '', tList ?? R);
        } else {
          return Resources<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return Resources<R>(Status.ERROR, "", obj.fromMap(result.data));
      }
    } else {
      return errorHandling(result);
    }
  }

  Future<Resources<R>> doServerCallMutationWithAuth<T extends Object<dynamic>, R>(T obj, Map<String, dynamic> jsonMap, String mutate) async
  {
    QueryResult result = await GraphQLConfiguration()
        .clientToQueryWithToken(PsSharedPreferences.instance.shared.getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN))
        .mutate(MutationOptions(
          document: gql(mutate),
          variables: jsonMap,
          fetchPolicy: FetchPolicy.networkOnly,
          errorPolicy: ErrorPolicy.all,
        )
    );

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return Resources<R>(Status.SUCCESS, '', tList ?? R);
        } else {
          return Resources<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return Resources<R>(Status.ERROR, "", obj.fromMap(result.data));
      }
    } else {
      return errorHandling(result);
    }
  }

  Future<Resources> mServerCallMutationWithAuth(
      Map<String, dynamic> jsonMap, String mutate) async {
    QueryResult result = await GraphQLConfiguration()
        .clientToQueryWithToken(PsSharedPreferences.instance.shared
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN))
        .mutate(MutationOptions(
          document: gql(mutate),
          variables: jsonMap,
          fetchPolicy: FetchPolicy.networkOnly,
          errorPolicy: ErrorPolicy.all,
        ));

    if (result.data != null) {
      return Resources(Status.SUCCESS, '', result.data);
    } else {
      return errorHandling(result);
    }
  }

  Future<Stream<QueryResult>>
      subscriptionUpdateConversationDetail<T extends Object<dynamic>, R>(
          T obj, Map<String, dynamic> jsonMap, String subscription) async {
    return GraphQLConfiguration()
        .clientToSubscriptionWithToken(PsSharedPreferences.instance.shared.getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN))
        .subscribe(SubscriptionOptions(
          document: gql(subscription),
          variables: jsonMap,
          fetchPolicy: FetchPolicy.networkOnly,
          errorPolicy: ErrorPolicy.all,
        ));
  }

  Future<Stream<QueryResult>>
      subscriptionOnlineMemberStatusDetail<T extends Object<dynamic>, R>(
          T obj, Map<String, dynamic> jsonMap, String subscription) async {

    return GraphQLConfiguration()
        .clientToSubscriptionWithToken(PsSharedPreferences.instance.shared
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN))
        .subscribe(SubscriptionOptions(
          document: gql(subscription),
          variables: jsonMap,
          fetchPolicy: FetchPolicy.networkOnly,
          errorPolicy: ErrorPolicy.all,
        ));
  }


  Future<Resources<R>> doServerCallQueryWithAuthQueryAndVairable<T extends Object<dynamic>, R>(T obj, String document, Map<String, dynamic> variable) async
  {
    GraphQLClient _client = GraphQLConfiguration().clientToQueryWithToken(
        PsSharedPreferences.instance.shared
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN));

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(document),
        variables: variable,
        pollInterval: Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    );

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return Resources<R>(Status.SUCCESS, '', tList ?? R);
        } else {
          return Resources<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return Resources<R>(Status.ERROR, "", obj.fromMap(result.data));
      }
    } else {
      return errorHandling(result);
    }
  }

  Future<Resources<R>> doServerCallQueryWithRefreshToken<T extends Object<dynamic>, R>(T obj, String document) async
  {
    GraphQLClient _client = GraphQLConfiguration().clientToQueryWithToken(PsSharedPreferences.instance.shared.getString(Const.VALUE_HOLDER_REFRESH_TOKEN));

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(document),
        pollInterval: Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    );

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return Resources<R>(Status.SUCCESS, '', tList ?? R);
        } else {
          return Resources<R>(Status.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return Resources<R>(Status.ERROR, "", obj.fromMap(result.data));
      }
    } else {
      return errorHandling(result);
    }
  }
}

Resources<R> errorHandling<T extends Object<dynamic>, R>(QueryResult result) {
  var data;
  try {
    if (result.hasException) {
      HttpLinkServerException sd = result.exception.linkException;
      var errorData = jsonDecode(sd.response.body);
      String status = errorData['status'].toString();
      if (status == "401" &&
          errorData['error']['error_key'] == "token_expired") {
        data = Resources<R>(
            Status.STATUS_CODE_401, errorData['error']['message'].toString(), null);
        UserProvider up = UserProvider(
            userRepository: UserRepository(), valueHolder: ValueHolder());
        up.onLogout(isTokenError: true);
      } else {
        data = Resources<R>(Status.ERROR, "", null);
      }
    } else {
      data = Resources<R>(Status.ERROR, "", null);
    }
  } catch (e) {
    data = Resources<R>(Status.ERROR, "", null);
  }
  PsProgressDialog.dismissDialog();
  return data;
}

// BaseClass mErrorHandling(QueryResult result) {
//   var data;
//   try {
//     if (result.hasException) {
//       HttpLinkServerException sd = result.exception.linkException;
//       var errorData = jsonDecode(sd.response.body);
//       String status = errorData['status'].toString();
//
//       if (status == "401" &&
//           errorData['error']['error_key'] == "token_expired") {
//
//         data = BaseClass(
//             Status.STATUS_CODE_401, errorData['error']['message'].toString(), null);
//         UserProvider up = UserProvider(
//             userRepository: UserRepository(), valueHolder: ValueHolder());
//         up.onLogout(isTokenError: true);
//       } else {
//         data = BaseClass(Status.ERROR, "", null);
//       }
//     } else {
//       data = BaseClass(Status.ERROR, "", null);
//     }
//   } catch (e) {
//     data = BaseClass(Status.ERROR, "", null);
//   }
//   PsProgressDialog.dismissDialog();
//   return data;
// }
