import 'package:graphql/client.dart';
import 'package:voice_example/api/LoggerHttpClient.dart';
import 'package:voice_example/config/Config.dart';
import 'package:http/http.dart' as http;
class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
    Config.liveUrl,
  );
  static WebSocketLink webSocketLink = WebSocketLink(
      Config.APP_SUBSCRIPTION_ENDPOINT,
      config: SocketClientConfig(
        autoReconnect: true,
        delayBetweenReconnectionAttempts: Duration(seconds: 1),
        queryAndMutationTimeout: const Duration(minutes: 30),
        inactivityTimeout: Duration(minutes: 30),
      ));

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        Config.liveUrl,
      ),
    );
  }

  GraphQLClient clientToQueryWithToken(String token) {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        Config.liveUrl,
        defaultHeaders: <String, String>{
          'Authorization': 'JWT $token',
        },
        httpClient: LoggerHttpClient(http.Client()),
      ),
    );
  }

  //Subscription
  GraphQLClient clientToSubscriptionWithToken(String token) {
    WebSocketLink webSocketLink = WebSocketLink(
        Config.APP_SUBSCRIPTION_ENDPOINT,
        config: SocketClientConfig(
          autoReconnect: true,
          initialPayload: () {
            return {
              'accessToken': "$token",
            };
          },
          delayBetweenReconnectionAttempts: Duration(seconds: 3),
          queryAndMutationTimeout: const Duration(minutes: 30),
          inactivityTimeout: Duration(minutes: 30),
        ));
    AuthLink authLink = AuthLink(
        getToken: () async {
          return "$token";
        },
        headerKey: "accessToken");
    Link link = authLink.concat(httpLink);
    if (webSocketLink != null) {
      link =
          Link.split((request) => request.isSubscription, webSocketLink, link);
    }
    return GraphQLClient(
        cache: GraphQLCache(), link: link, alwaysRebroadcast: true);
  }
  GraphQLClient pingSubscriptionData(String token) {
    WebSocketLink webSocketLink = WebSocketLink(
        Config.APP_SUBSCRIPTION_ENDPOINT,
        config: SocketClientConfig(
          autoReconnect: true,
          initialPayload: () {
            return {
              'accessToken': "$token",
              'type': 'ping',
              'id': '_id',
              'payload': {'timestamp': DateTime.now().millisecondsSinceEpoch}
            };
          },
          delayBetweenReconnectionAttempts: Duration(seconds: 3),
          queryAndMutationTimeout: const Duration(minutes: 30),
          inactivityTimeout: Duration(minutes: 30),
        ));
    AuthLink authLink = AuthLink(
        getToken: () async {
          return "$token";
        },
        headerKey: "accessToken");
    Link link = authLink.concat(httpLink);
    if (webSocketLink != null) {
      link =
          Link.split((request) => request.isSubscription, webSocketLink, link);
    }
    return GraphQLClient(
        cache: GraphQLCache(), link: link, alwaysRebroadcast: true);
  }

}
///aba k garnu parne ho yespaxi