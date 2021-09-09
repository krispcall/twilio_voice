import 'dart:async';
import 'dart:convert';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/constant/Constants.dart';
import 'package:voice_example/db/common/ps_shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

// class StreamBase {
//   static final StreamBase _streamBase = StreamBase._internal();
//   factory StreamBase() {
//     return _streamBase;
//   }
//   StreamBase._internal();
//
//   IOWebSocketChannel channel;
//   initConnection() {
//     String token = PsSharedPreferences.instance.shared
//         .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN);
//     channel = IOWebSocketChannel.connect(Config.APP_SUBSCRIPTION_ENDPOINT,
//         // headers: {
//         //   'accessToken': "$token",
//         // },
//         // pingInterval: Duration(seconds: 20)
//     );
//
//     return channel;
//   }
//
//   closeChannel() {
//     channel.sink.close();
//   }
// }




class WebSocketController {

  static final WebSocketController _singleton = new WebSocketController._internal();

  StreamController<String> streamController = new StreamController.broadcast(sync: true);

  String wsUrl = Config.APP_SUBSCRIPTION_ENDPOINT;
  String token = PsSharedPreferences.instance.shared.getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN);

  IOWebSocketChannel channel;
  Timer timer ;
  Timer timerMemberSocket;

  factory WebSocketController() {
    return _singleton;
  }

  WebSocketController._internal() {
    initWebSocketConnection();
  }

  initWebSocketConnection() async
  {
    this.channel = await connectWs();
    initDataSend();
    broadcastNotifications();
  }

  broadcastNotifications() {
    this.channel.stream.listen((streamData) {
      streamController.add(streamData);
    }, onDone: () {
      timerMemberSocket?.cancel();
      // initWebSocketConnection();
    }, onError: (e) {
      initWebSocketConnection();
    });
  }
  // SocketIoManager.socketEvents['deviceOnline']
  initDataSend()async{
    String token = PsSharedPreferences.instance.shared
        .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN);
    await Future.delayed(Duration(milliseconds: 5000));
    Map initConnection = {"type":"connection_init","payload":{"accessToken":"$token"}};
    channel.sink.add(json.encode(initConnection));
  }

  sendData(){

    timerMemberSocket = Timer.periodic(Duration(seconds: 20), (timer) {
      Map pingData = {"id":"_id","type":"ping","payload":{"timestamp": "${DateTime.now().millisecondsSinceEpoch}"}};
      channel.sink.add(json.encode(pingData));
    });

  }

  onClose(){
    timerMemberSocket?.cancel();
    timer?.cancel() ;
    channel?.sink?.close();
  }

  connectWs() async{
    try {
      return  IOWebSocketChannel.connect(wsUrl);
    } catch  (e) {
      await Future.delayed(Duration(milliseconds: 20000));
      return await connectWs();
    }

  }

  void _onDisconnected() {
    initWebSocketConnection();
  }
}
