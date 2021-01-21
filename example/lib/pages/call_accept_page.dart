
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:voice_example/main.dart';

class CallAcceptPage extends StatefulWidget
{

  String get results => receivedNotification.toString();
  final ReceivedNotification receivedNotification;
  bool isConnected=true;
  CallAcceptPage(this.receivedNotification,this.isConnected);

  @override
  _CallAcceptPage createState() => _CallAcceptPage();
}

class _CallAcceptPage extends State<CallAcceptPage> {

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void deactivate()
  {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context)
  {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    ImageProvider largeIcon = widget.receivedNotification.largeIconImage;
    ImageProvider bigPicture = widget.receivedNotification.bigPictureImage;

    if(largeIcon == bigPicture) largeIcon = null;


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child:Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  widget.receivedNotification.displayedDate,
                ),
              ),
              Container(
                child: Text(
                  widget.receivedNotification.title,
                ),
              ),
              Container(
                child: Text(
                  widget.receivedNotification.body,
                ),
              ),
              widget.isConnected?
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        side: BorderSide(color: Colors.red),
                      ),
                      color: Colors.red,
                      onPressed:()
                      {
                        voiceClient.rejectCall();
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.clear_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        side: BorderSide(color: Colors.green),
                      ),
                      color: Colors.green,
                      onPressed:()
                      {
                        voiceClient.acceptCall();
                        setState(() {
                          widget.isConnected=false;
                        });
                      },
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ):
              Container(
                height: 50,
                width: 50,
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    side: BorderSide(color: Colors.red),
                  ),
                  color: Colors.red,
                  onPressed:()
                  {
                    voiceClient.rejectCall();
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.clear_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}