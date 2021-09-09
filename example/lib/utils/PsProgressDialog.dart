import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PsProgressDialog
{
  PsProgressDialog._();

  static ProgressDialog _progressDialog;

  static void showDialog(BuildContext context, {String message})
  {
    if (_progressDialog == null)
    {
      _progressDialog = ProgressDialog(
          context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: true
      );

      _progressDialog.style(
          message: message ?? Utils.getString('pleaseWait'),
          borderRadius: 5.0,
          backgroundColor: Utils.isLightMode(context) ? CustomColors.white : CustomColors.backgroundColor,
          progressWidget: SpinKitCircle(
            color: CustomColors.mainColor,
          ),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(
              color: CustomColors.textPrimaryColor,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space14.sp,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal
          ),
          messageTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(
              color: CustomColors.textPrimaryColor,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space14.sp,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal
          ),
      );
    }

    if (message != null)
    {
      _progressDialog.update(
          message: message ?? Utils.getString('pleaseWait')
      );
    }

    _progressDialog.show();
  }

  static void dismissDialog()
  {
    if (_progressDialog != null)
    {
      _progressDialog.hide();
      _progressDialog = null;
    }
  }

  static bool isShowing()
  {
    if (_progressDialog != null)
    {
      return _progressDialog.isShowing();
    }
    else
    {
      return false;
    }
  }

  static void showDownloadDialog(BuildContext context, double progress, {String message})
  {
    if (_progressDialog == null)
    {
      _progressDialog = ProgressDialog(context,
          type: ProgressDialogType.Download,
          isDismissible: false,
          showLogs: true
      );

      _progressDialog.style(
          message:
              message ?? Utils.getString('pleaseWait'),
          borderRadius: 5.0,
          backgroundColor: CustomColors.white,
          progressWidget: Container(
              padding: const EdgeInsets.all(10.0),
              child: const CircularProgressIndicator()),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: progress,
          maxProgress: 100.0,
          progressTextStyle: Theme.of(context).textTheme.bodyText2,
          messageTextStyle: Theme.of(context).textTheme.bodyText2);
    }

    _progressDialog.update(
        message: message ?? Utils.getString('pleaseWait'),
        progress: progress);

    if (!_progressDialog.isShowing()) {
      _progressDialog.show();
    }
  }

  static void dismissDownloadDialog() {
    if (_progressDialog != null) {
      _progressDialog.hide();
      _progressDialog = null;
    }
  }
}
