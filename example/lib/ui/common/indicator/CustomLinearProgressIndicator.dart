import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/config/CustomColors.dart';

class CustomLinearProgressIndicator extends StatefulWidget {
  const CustomLinearProgressIndicator(this.status);
  final Status status;

  @override
  CustomLinearProgressIndicatorState createState() => CustomLinearProgressIndicatorState();
}

class CustomLinearProgressIndicatorState extends State<CustomLinearProgressIndicator>
{
  @override
  Widget build(BuildContext context)
  {
    return Align(
      alignment: Alignment.center,
      child: Opacity(
        opacity: widget.status == Status.PROGRESS_LOADING ? 1 : 0,
        child: LinearProgressIndicator(
          color: CustomColors.mainColor,
          backgroundColor: CustomColors.white,
        ),
      ),
    );
  }
}

