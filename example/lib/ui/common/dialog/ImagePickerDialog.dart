import 'package:flutter/material.dart';
import 'package:voice_example/config/CustomColors.dart';

class ImagePickerDialog extends StatelessWidget
{
  const ImagePickerDialog({Key key,this.onCameraTap,this.onGalleryTap}) : super(key: key);
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;



  @override
  Widget build(BuildContext context)
  {
    return new Container(
        height: 200.0,
        color: Colors.transparent,
        //could change this to Color(0xFF737373),
        //so you don't have to change MaterialApp canvasColor
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: new Radius.circular(20.0),
                topRight: new Radius.circular(20.0)),
          ),
          child: new Container(
            width: double.infinity,
            child: new Column(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.symmetric(vertical: 10.0),
                  child: new ClipRRect(
                    borderRadius: new BorderRadius.circular(4.0),
                    child: new Image.asset(
                      'assets/images/logo.png',
                      width: 50,
                      height: 8,
                    ),
                  ),
                ),
                new Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Color(0xFFF6F6F6),
                ),
                new Container(
                  margin: new EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 20, bottom: 20.0),
                  child: Material(
                    color: Colors.transparent,
                    child: new InkWell(
                      onTap: onGalleryTap,
                      child: new Row(
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                              color: CustomColors.mainColor,
                              //new Color.fromRGBO(255, 0, 0, 0.0),
                              borderRadius:
                              new BorderRadius.circular(20.0),
                            ),
                            child: Icon(
                              Icons.insert_drive_file,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          new Flexible(
                              flex: 1,
                              child: new Container(
                                alignment: FractionalOffset.centerLeft,
                                margin: const EdgeInsets.fromLTRB(
                                    20, 0, 0, 0),
                                child: new Text(
                                  "Gallery",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1E1F20)),
                                ),
                              )),
                          new Container(
                            child: new Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0xFF9393AA),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 20, bottom: 20.0),
                  child: Material(
                    color: Colors.transparent,
                    child: new InkWell(
                      onTap: onCameraTap,
                      child: new Row(
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            margin: new EdgeInsets.fromLTRB(10, 0, 0, 0),
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                              color: CustomColors.mainColor,
                              //new Color.fromRGBO(255, 0, 0, 0.0),
                              borderRadius:
                              new BorderRadius.circular(20.0),
                            ),
                            child: Icon(
                              Icons.camera,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          new Flexible(
                              flex: 1,
                              child: new Container(
                                alignment: FractionalOffset.centerLeft,
                                margin: const EdgeInsets.fromLTRB(
                                    20, 0, 0, 0),
                                child: new Text(
                                  "Camera",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1E1F20)),
                                ),
                              )),
                          new Container(
                            child: new Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0xFF9393AA),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
