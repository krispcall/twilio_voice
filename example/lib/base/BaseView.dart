
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voice_example/colors/colors.dart';
import 'package:voice_example/string/Strings.dart';
import 'package:voice_example/styles/CustomStyles.dart';
import 'BasePresenter.dart';
import 'BaseViewCallback.dart';

abstract class BaseView<S extends State<StatefulWidget>> extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => state();

  S state();
}

abstract class BaseState<P extends BasePresenter, V extends BaseView>
    extends State<V> implements BaseViewCallback {
  @protected
  P presenter;

  bool _contentVisible = true;
  bool _isLoading = false;

  BaseState()
  {
    presenter = Injector.getInjector().get();
    presenter.view = this;
  }

  @override
  void initState()
  {
    super.initState();
    presenter.init();
  }

  @override
  dispose()
  {
    presenter.dispose();
    super.dispose();
  }

  @override
  showProgress({bool contentVisible = false})
  {
    setState(() {
      _contentVisible = true;
      _isLoading = true;
    });
  }

  @override
  hideProgress() {
    setState(() {
      _contentVisible = true;
      _isLoading = false;
    });
  }

  @override
  onError(Object error) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return Center(
            child:Card(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              elevation: 5,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),bottomRight:  Radius.circular(0),topLeft:  Radius.circular(5),topRight:  Radius.circular(5)),
                            color: CustomColor.themeGreen,
                        ),
                        child:Text(
                          Strings.error,
                          style: blackLabel12BoldTextStyle,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                        alignment: Alignment.centerLeft,
                        child:Icon(Icons.error_outline,color: Colors.white),
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child:Text(
                        error.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Avenir",
                            letterSpacing: .0)
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: FlatButton(
                          onPressed: (){
                            pop();
                          },
                          child: Text(
                              Strings.okay,
                              style: TextStyle(
                                  color: CustomColor.themeGreen,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Avenir",
                                  letterSpacing: .0)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  @protected
  writeStorageValue<T>(Object key, T value) {
    PageStorage.of(context).writeState(context, value, identifier: key);
  }

  @protected
  T readStorageValue<T>(Object key) {
    return PageStorage.of(context).readState(context, identifier: key);
  }

  @protected
  push(Widget view, {bool withReplacement = true}) {
    final route = CupertinoPageRoute(builder: (context) => view);
    if (withReplacement) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }

  pop() => Navigator.pop(context);

  popValue(bool value) => Navigator.pop(context,value);

  @override
  Widget build(BuildContext context)
  {
    return Container(
      child: Stack(children: [
        Visibility(visible: _contentVisible, child: create(context)),
        Center(
          child: Visibility(
            visible: _isLoading,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(CustomColor.themeGreen),
            ),
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: Opacity(
            opacity:0.5 ,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        ),
      ])
    );
  }

  Widget create(BuildContext context);

}
