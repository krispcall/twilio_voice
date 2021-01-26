
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class CallOutgoing extends StatefulWidget
{

  String get results => to;
  final String to;
  CallOutgoing(this.to);

  @override
  _CallOutgoing createState() => _CallOutgoing();
}

class _CallOutgoing extends State<CallOutgoing> {

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
                  widget.to,
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
                    side: BorderSide(color: Colors.red),
                  ),
                  color: Colors.red,
                  onPressed:()
                  {
                    // voiceClient.rejectCall();
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