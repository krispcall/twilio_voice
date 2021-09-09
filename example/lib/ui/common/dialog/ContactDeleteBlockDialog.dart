import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/ui/common/dialog/BlockContactDialog.dart';
import 'package:voice_example/ui/common/dialog/DeleteContactDialog.dart';
import 'package:voice_example/utils/Utils.dart';

class ContactDeleteBlockDialog extends StatefulWidget {
  final bool blocked;
  final Function blockCallBack;
  final Function deleteCallBack;

  const ContactDeleteBlockDialog({Key key, this.blocked, this.blockCallBack,this.deleteCallBack }) : super(key: key);
  @override
  ContactDeleteBlockDialogState createState() =>
      ContactDeleteBlockDialogState();
}

class ContactDeleteBlockDialogState extends State<ContactDeleteBlockDialog>
    with SingleTickerProviderStateMixin {
  ApiService apiService = ApiService();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimens.space16.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
      child: Container(
        height: Dimens.space215.h,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: Dimens.space96.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.space16.r)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.of(context).pop();
                      showBlockContactDialog(context: context);
                    },
                    child: Container(
                      height: Dimens.space48.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            //                    <--- top side
                            color: CustomColors.callInactiveColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                         widget.blocked? Utils.getString("unblockContact"): Utils.getString('blockContact'),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: CustomColors.textSenaryColor,
                            fontFamily: Config.manropeBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.of(context).pop();
                      showDeleteContactDialog(context: context);
                      // Navigator.of(context).pop({"data": true, "action": "delete"});
                    },
                    child: Container(
                      height: Dimens.space48.h,
                     child: Center(
                        child: Text(
                          Utils.getString('deleteContact'),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: CustomColors.textPrimaryErrorColor,
                            fontFamily: Config.manropeBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimens.space16.h),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: Dimens.space48.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimens.space16.r)),
                child: Center(
                  child: Text(
                    Utils.getString('cancel'),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: CustomColors.textSenaryColor,
                          fontFamily: Config.manropeBold,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimens.space32.h),
          ],
        ),
      ),
    );
  }


  void showDeleteContactDialog({BuildContext context}) async {
    final dynamic returnData = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DeleteContactDialog();
        });
    if (returnData != null &&
        returnData["data"] is bool &&
        returnData["data"]) {
      if (returnData["action"] == "delete") {
        Navigator.of(context).pop({"data": true, "action": "delete"});
      }
    }


}

  void showBlockContactDialog({BuildContext context}) async {
    final dynamic returnData = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return BlockContactDialog(block: widget.blocked,);
        });

    if (returnData != null &&
        returnData["data"] is bool &&
        returnData["data"]) {
      if (returnData["action"] == "block") {
        Navigator.of(context).pop({"data": true, "action": "block"});
      }
    }
  }




}
