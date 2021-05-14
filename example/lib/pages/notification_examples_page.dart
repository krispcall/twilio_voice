
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:voice_example/Constants/Constants.dart';

class NotificationExamplesPage extends StatefulWidget
{

  @override
  _NotificationExamplesPageState createState() => _NotificationExamplesPageState();
}

class _NotificationExamplesPageState extends State<NotificationExamplesPage>
{
  String _platformVersion = 'Unknown';
  TextEditingController _toController, _fromController;
  bool notificationsAllowed = false;
  MediaQueryData mediaQuery;

  DateTime _pickedDate;
  TimeOfDay _pickedTime;

  bool delayLEDTests = false;
  String targetPage="";

  @override
  void initState()
  {
    _toController = TextEditingController();
    _fromController = TextEditingController(text: "support_agent_+61480031300");
    AwesomeNotifications().createdStream.listen(
            (receivedNotification) {
          String createdSourceText = AssertUtils.toSimpleEnumString(
              receivedNotification.createdSource);
          Fluttertoast.showToast(
              msg: '$createdSourceText notification created');
        }
    );

    AwesomeNotifications().displayedStream.listen(
            (receivedNotification) {
          String createdSourceText = AssertUtils.toSimpleEnumString(
              receivedNotification.createdSource);
          Fluttertoast.showToast(
              msg: '$createdSourceText notification displayed');
        }
    );

    AwesomeNotifications().dismissedStream.listen((receivedNotification) {
          String dismissedSourceText = AssertUtils.toSimpleEnumString(receivedNotification.dismissedLifeCycle);
          Fluttertoast.showToast(
              msg: 'Notification dismissed on $dismissedSourceText');
        }
    );

    AwesomeNotifications().actionStream.listen((receivedNotification) {
          if (!StringUtils.isNullOrEmpty(receivedNotification.buttonKeyInput))
          {
            processInputTextReceived(receivedNotification);
          }
          else
          {
            processDefaultActionReceived(receivedNotification);
          }
        }
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      setState(() {
        notificationsAllowed = isAllowed;
      });

      if (!isAllowed) {
        requestUserPermission(isAllowed);
      }
    });

    super.initState();
  }

  @override
  void dispose()
  {
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  Future<bool> pickScheduleDate(BuildContext context) async {
    TimeOfDay timeOfDay;
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: _pickedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))
    );

    if(newDate!= null){

      timeOfDay = await showTimePicker(
        context: context,
        initialTime: _pickedTime ?? TimeOfDay.now(),
      );

      if(timeOfDay != null && (_pickedDate != newDate || _pickedTime != timeOfDay)){
        setState(() {
          _pickedTime = timeOfDay;
          _pickedDate = DateTime(newDate.year, newDate.month, newDate.day, timeOfDay.hour, timeOfDay.minute);
        });
        return true;
      }
      return false;
    }

    return false;
  }

  Future<int> pickBadgeCounter(BuildContext context) async {
    int amount = 50;

    AlertDialog alert = AlertDialog(
      title: Text("Choose the new badge amount"),
      content: NumberPicker(
          value: amount,
          minValue: 0,
          maxValue: 999,
          onChanged: (newValue) => amount = newValue
      ),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: (){
            amount = null;
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    await showDialog(
        context: context,
        builder: (BuildContext context) => alert
    );

    return amount;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twilio Voice Example'),
      ),
      body: SafeArea(
          child: Center(
            child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Running on: $_platformVersion\n'),
                  ),
                  TextFormField(
                    controller: _fromController,
                    decoration: InputDecoration(
                        labelText: 'Sender Identifier or Phone Number'),
                  ),
                  Divider(),
                  TextFormField(
                    controller: _toController,
                    decoration: InputDecoration(
                        labelText: 'Receiver Identifier or Phone Number'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    child: Text("Make Call"),
                    onPressed: () async
                    {
                      targetPage = Constants.PAGE_CALL_OUTGOING;
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          targetPage,
                              (route) => (route.settings.name != targetPage) || route.isFirst,
                        arguments:_toController.text
                      );
                      // await voiceClient.makeCall(
                      //   accessToken,
                      //   _fromController.text,
                      //   _toController.text,
                      //   "joshan",
                      // );
                    },
                  ),
                ]),
          )
      ),
    );
  }

  void requestUserPermission(bool isAllowed) async {
    showDialog(
        context: context,
        builder: (_) =>
            NetworkGiffyDialog(
              buttonOkText: Text('Allow', style: TextStyle(color: Colors.white)),
              buttonCancelText: Text('Later', style: TextStyle(color: Colors.white)),
              buttonCancelColor: Colors.grey,
              buttonOkColor: Colors.deepPurple,
              buttonRadius: 0.0,
              image: Image.asset("assets/images/animated-bell.gif", fit: BoxFit.cover),
              title: Text('Get Notified!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600)
              ),
              description: Text('Allow Awesome Notifications to send you beautiful notifications!',
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              onCancelButtonPressed: () async {
                Navigator.of(context).pop();
                notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  notificationsAllowed = notificationsAllowed;
                });
              },
              onOkButtonPressed: () async {
                Navigator.of(context).pop();
                await AwesomeNotifications().requestPermissionToSendNotifications();
                notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  notificationsAllowed = notificationsAllowed;
                });
              },
            )
    );
  }

  void processDefaultActionReceived(ReceivedAction receivedNotification) async
  {
    await AwesomeNotifications().cancel(Constants.NOTIFICATION_CALL_INCOMING);
    Fluttertoast.showToast(msg: 'Action received');

    // Avoid to reopen the media page if is already opened
    if(receivedNotification.buttonKeyPressed=='accept')
    {
      targetPage = Constants.PAGE_CALL_INCOMING;
      Navigator.pushNamedAndRemoveUntil(
          context,
          targetPage,
              (route) => (route.settings.name != targetPage) || route.isFirst,
          arguments: receivedNotification
      );
      // voiceClient.acceptCall();
    }
    else if(receivedNotification.buttonKeyPressed=='decline')
    {
      targetPage = Constants.PAGE_CALL_INCOMING;
      Navigator.pushNamedAndRemoveUntil(
          context,
          targetPage,
              (route) => (route.settings.name != targetPage) || route.isFirst,
          arguments: receivedNotification
      );
      // voiceClient.rejectCall();
    }
    else
    {
      targetPage = Constants.PAGE_CALL_INCOMING;
      Navigator.pushNamedAndRemoveUntil(
          context,
          targetPage,
              (route) => (route.settings.name != targetPage) || route.isFirst,
          arguments: receivedNotification
      );
    }

    // Avoid to open the notification details page over another details page already opened

  }

  void processInputTextReceived(ReceivedAction receivedNotification)
  {
    Fluttertoast.showToast(msg: 'Msg: '+receivedNotification.buttonKeyInput,textColor: Colors.white);
  }
}