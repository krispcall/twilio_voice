import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/editTagRequestParamHolder/EditTagRequestParamHolder.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/model/allTags/EditTagResponse.dart';
import 'package:provider/provider.dart';

class EditTagViewWidget extends StatefulWidget {
  final Tags tag;
  final Function(String changedTitle) callBack;

  const EditTagViewWidget({Key key, this.tag, this.callBack}) : super(key: key);

  @override
  EditTagViewState createState() => EditTagViewState();
}

class EditTagViewState extends State<EditTagViewWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final TextEditingController titeTextEditingController =
      TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  ContactsProvider contactsProvider;
  ContactRepository contactRepository;
  ValueHolder valueHolder;
  Animation animation;

  Tags selecteTag;

  @override
  void initState() {
    selecteTag = widget.tag;
    titeTextEditingController.text = widget.tag.title;
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    animationController.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    contactRepository = Provider.of<ContactRepository>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.mainBackgroundColor,
      body: ChangeNotifierProvider<ContactsProvider>(
          lazy: false,
          create: (BuildContext context) {
            this.contactsProvider =
                ContactsProvider(contactRepository: contactRepository);
            return contactsProvider;
          },
          child: Consumer<ContactsProvider>(builder:
              (BuildContext context, ContactsProvider provider, Widget child) {
            animationController.forward();
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController,
                    curve: const Interval(0.5 * 1, 1.0,
                        curve: Curves.fastOutSlowIn)));
            return AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                    opacity: animation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                            Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space30.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: CustomTextField(
                                  height: Dimens.space48,
                                  titleText: Utils.getString("tagName"),
                                  containerFillColor:
                                      CustomColors.baseLightColor,
                                  borderColor: CustomColors.secondaryColor,
                                  corner: Dimens.space10,
                                  titleFont: Config.manropeBold,
                                  titleTextColor:
                                      CustomColors.textSecondaryColor,
                                  titleFontSize: Dimens.space14,
                                  titleFontStyle: FontStyle.normal,
                                  titleFontWeight: FontWeight.w700,
                                  titleMarginLeft: Dimens.space0,
                                  titleMarginRight: Dimens.space0,
                                  titleMarginBottom: Dimens.space6,
                                  titleMarginTop: Dimens.space0,
                                  hintText: Utils.getString('contactName'),
                                  hintFontColor:
                                      CustomColors.textQuaternaryColor,
                                  hintFontFamily: Config.heeboRegular,
                                  hintFontSize: Dimens.space16,
                                  hintFontStyle: FontStyle.normal,
                                  hintFontWeight: FontWeight.normal,
                                  inputFontColor:
                                      CustomColors.textQuaternaryColor,
                                  inputFontFamily: Config.heeboRegular,
                                  inputFontSize: Dimens.space16,
                                  inputFontStyle: FontStyle.normal,
                                  inputFontWeight: FontWeight.normal,
                                  textEditingController:
                                      titeTextEditingController,
                                  showTitle: true,
                                  autoFocus: false,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space18.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: TagColorWidget(
                                  tag: selecteTag,
                                  onTap: (Tags value) async {},
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space30.h,
                                    Dimens.space0.w,
                                    Dimens.space34.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: RoundedButtonWidget(
                                  width: double.maxFinite,
                                  height: Dimens.space54,
                                  buttonBackgroundColor: CustomColors.mainColor,
                                  buttonTextColor: CustomColors.white,
                                  corner: Dimens.space10,
                                  buttonBorderColor: CustomColors.mainColor,
                                  buttonFontFamily: Config.manropeSemiBold,
                                  buttonFontSize: Dimens.space16,
                                  titleTextAlign: TextAlign.center,
                                  buttonFontWeight: FontWeight.normal,
                                  buttonText: Utils.getString('saveChanges'),
                                  onPressed: () async {
                                    Utils.removeKeyboard(context);
                                    if (titeTextEditingController
                                        .text.isEmpty) {
                                      showDialog<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ErrorDialog(
                                              message: Utils.getString(
                                                  'fullNameEmpty'),
                                            );
                                          });
                                    } else {
                                      if (await Utils
                                          .checkInternetConnectivity()) {
                                        /*TODO: need tor replace the company name*/
                                        final EditTagRequestParamHolder
                                            editTagRequestHolder =
                                            EditTagRequestParamHolder(
                                                id: widget.tag.id,
                                                data: Map.from({
                                                  "title":
                                                      titeTextEditingController
                                                          .text
                                                }));
                                        PsProgressDialog.showDialog(context);
                                        final Resources<EditTagResponse>
                                            editTagResponse =
                                            await contactsProvider
                                                .doEditTagTitleApiCall(
                                                    editTagRequestHolder
                                                        .toMap());
                                        if (editTagResponse != null &&
                                            editTagResponse.data != null) {
                                          PsProgressDialog.dismissDialog();
                                          widget.callBack(titeTextEditingController.text);
                                          Utils.showToastMessage(
                                              "Edit tag successful");
                                        } else if (editTagResponse != null &&
                                            editTagResponse.message != null) {
                                          PsProgressDialog.dismissDialog();
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ErrorDialog(
                                                  message:
                                                      editTagResponse.message,
                                                );
                                              });
                                        }
                                      } else {
                                        showDialog<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ErrorDialog(
                                                message: Utils.getString(
                                                    'noInternet'));
                                          },
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          })),
    );
  }
}

class TagColorWidget extends StatelessWidget {
  final Tags tag;
  final Function onTap;

  const TagColorWidget({Key key, this.tag, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
              color: CustomColors.baseLightColor,
              offset: Offset(0, 0.5),
              blurRadius: 0)
        ],
        color: CustomColors.baseLightColor,
        border: Border.all(
          color: CustomColors.callInactiveColor,
          width: 1,
        ),
      ),
      padding: EdgeInsets.only(
          left: Dimens.space16.h,
          right: Dimens.space0,
          top: Dimens.space0,
          bottom: Dimens.space0),
      child: InkWell(
        onTap: () {
          onTap(tag);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.space0, vertical: Dimens.space4.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      Utils.getString("tagColor"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: 'Manrope',
                          fontSize: Dimens.space15.sp,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1.0666),
                    ),
                  )),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedAssetImageHolder(
                    width: Dimens.space36,
                    height: Dimens.space36,
                    boxFit: BoxFit.contain,
                    iconUrl: CustomIcon.icon_tag,
                    iconColor: CustomColors.white,
                    iconSize: Dimens.space18,
                    boxDecorationColor: Utils.hexToColor(tag.colorCode),
                    outerCorner: Dimens.space20,
                    innerCorner: Dimens.space20,
                    containerAlignment: Alignment.center,
                    assetUrl: "",
                  ),
                ),
              ),
              Container(
                width: Dimens.space30.w,
                alignment: Alignment.center,
                child: Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
