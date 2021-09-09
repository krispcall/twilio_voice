import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:voice_example/api/StreamBase.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/user/UserProvider.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/dialog/ConfirmDialogView.dart';
import 'package:voice_example/utils/DeBouncer.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/viewobject/model/onlineStatus/onlineStatusResponse.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfile extends StatefulWidget {
  UserProfile({
    Key key,
    this.animationController,
    @required this.onLogOut,
  }) : super(key: key);

  final AnimationController animationController;
  final Function onLogOut;

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;
  UserProvider userProvider;
  ValueHolder valueHolder;

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);
    widget.animationController.forward();

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              this.userProvider = UserProvider(
                  userRepository: userRepository, valueHolder: valueHolder);
              userProvider.getUserProfileDetails();
              return userProvider;
            }),
      ],
      child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimens.space16.w),
                  topLeft: Radius.circular(Dimens.space16.w)),
              color: CustomColors.white,
            ),
            padding: EdgeInsets.fromLTRB(
                Dimens.space0, Dimens.space15, Dimens.space0, Dimens.space0),
            child: ListView(
              children: [
                HeaderImageAndTextWidget(
                  userProvider: userProvider,
                  callback: () {},
                  valueHolder: valueHolder,
                ),
                DetailWidget(
                  userProvider: userProvider,
                ),
                Divider(
                  height: Dimens.space20,
                  thickness: Dimens.space20,
                  color: CustomColors.bottomAppBarColor,
                ),
                LogoutWidget(
                  userProvider: userProvider,
                  onLogOut: widget.onLogOut,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileDetailWidget extends StatefulWidget {
  ProfileDetailWidget({
    Key key,
    this.animationController,
    this.animation,
    @required this.userProvider,
    @required this.valueHolder,
    @required this.onLogOut,
    @required this.onToggle,
    @required this.status,
    @required this.onUserFieldUpdated,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final UserProvider userProvider;
  final ValueHolder valueHolder;
  final Function onLogOut;
  final Function(bool) onToggle;
  final VoidCallback onUserFieldUpdated;
  final bool status;

  @override
  ProfileDetailWidgetState createState() => ProfileDetailWidgetState();
}

class ProfileDetailWidgetState extends State<ProfileDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.userProvider.valueHolder.loginUserId != null
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimens.space16.w),
                  topLeft: Radius.circular(Dimens.space16.w)),
              color: CustomColors.backgroundColor,
            ),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                HeaderImageAndTextWidget(
                    userProvider: widget.userProvider,
                    valueHolder: widget.valueHolder,
                    callback: widget.onUserFieldUpdated),
                DetailWidget(
                  userProvider: widget.userProvider,
                ),
                // _EditAndHistoryRowWidget(userProvider: widget.userProvider),
                Divider(
                  height: Dimens.space40,
                  thickness: Dimens.space40,
                  color: CustomColors.bottomAppBarColor,
                ),
                // _FavAndSettingWidget(),
                // _dividerWidget,
                DeleteWidget(
                  userProvider: widget.userProvider,
                  onLogOut: () {
                    widget.onLogOut();
                    Navigator.of(context).pop();
                  },
                ),
                Divider(
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                  color: CustomColors.mainDividerColor,
                ),
                LogoutWidget(
                  userProvider: widget.userProvider,
                  onLogOut: widget.onLogOut,
                )
              ],
            ),
          )
        : Container();
  }
}

class HeaderImageAndTextWidget extends StatelessWidget {
  HeaderImageAndTextWidget(
      {this.userProvider, this.callback, this.valueHolder});

  final VoidCallback callback;
  final UserProvider userProvider;
  final ValueHolder valueHolder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(Dimens.space0,
          Utils.getStatusBarHeight(context), Dimens.space0, Dimens.space0),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space20.w, Dimens.space0, Dimens.space20.w),
      alignment: Alignment.topLeft,
      color: CustomColors.white,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space2, Dimens.space0.h, Dimens.space2),
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0,
                  Dimens.space16.w, Dimens.space0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space80,
                          height: Dimens.space80,
                          boxFit: BoxFit.fill,
                          iconUrl: CustomIcon.icon_gallery,
                          iconColor: CustomColors.callInactiveColor,
                          iconSize: Dimens.space40,
                          outerCorner: Dimens.space20,
                          innerCorner: Dimens.space12,
                          imageUrl: userProvider.getDefaultChannel() != null &&
                                  userProvider
                                          .getDefaultChannel()
                                          .countryLogo !=
                                      null
                              ? Config.countryLogoUrl +
                                  userProvider.getDefaultChannel().countryLogo
                              : "",
                        ),
                      ),
                      Positioned(
                        right: Dimens.space2.w,
                        bottom: Dimens.space0.w,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: CustomColors.white,
                          ),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space3.w,
                              Dimens.space3.w,
                              Dimens.space3.w,
                              Dimens.space3.w),
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space15,
                            height: Dimens.space15,
                            boxFit: BoxFit.cover,
                            iconUrl: CustomIcon.icon_plus,
                            iconColor: CustomColors.white,
                            iconSize: Dimens.space12,
                            boxDecorationColor: CustomColors.mainColor,
                            outerCorner: Dimens.space300,
                            innerCorner: Dimens.space300,
                            imageUrl: "",
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.topRight,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomColors.startButtonColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(Dimens.space8.w,
                              Dimens.space6, Dimens.space8.w, Dimens.space6),
                          child: Text(
                            "ADMIN",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: CustomColors.white,
                                    fontSize: Dimens.space12.sp,
                                    fontFamily: Config.heeboRegular,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h,
                  Dimens.space0, Dimens.space12.h),
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0,
                  Dimens.space16.w, Dimens.space0),
              child: Container(
                child: Text(
                  userProvider.getDefaultChannel().name,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeExtraBold,
                      fontSize: Dimens.space20.sp,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10.h,
                  Dimens.space0.h, Dimens.space2),
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0,
                  Dimens.space16.w, Dimens.space0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userProvider?.getUserEmail() ??
                        userProvider?.getDefaultChannel()?.number ??
                        '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: CustomColors.textTertiaryColor,
                        fontSize: Dimens.space15.sp,
                        fontFamily: Config.heeboRegular,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailWidget extends StatefulWidget {
  final UserProvider userProvider;

  DetailWidget({
    @required this.userProvider,
  });

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  bool isOnline = true;
  final _debouncer = DeBouncer(milliseconds: 500);
  WebSocketController webSocketController = WebSocketController();

  switchStatus(bool data) {
    _debouncer.run(() async {
      Map requestData = {'onlineStatus': data};
      Resources<OnlineStatusResponse> response =
          await widget.userProvider.onlineStatus(requestData);
      if (response.data.data.data.onlineStatus) {
        webSocketController.initWebSocketConnection();
        webSocketController.sendData();
      } else {
        webSocketController.onClose();
      }
    });
    isOnline = data;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isOnline = widget.userProvider.getUserOnlineStatus();
    if (!isOnline) {
      webSocketController.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            color: CustomColors.bottomAppBarColor,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space15.h,
                Dimens.space16.w, Dimens.space10.h),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space16.h,
                Dimens.space16.w, Dimens.space16.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CustomColors.mainDividerColor,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Utils.getString("setStatus"),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeSemiBold,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.normal),
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isOnline
                        ? Container(
                            width: Dimens.space10.w,
                            height: Dimens.space10.w,
                            decoration: BoxDecoration(
                              color: CustomColors.callAcceptColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r)),
                            ))
                        : Container(),
                    SizedBox(
                      width: Dimens.space8.w,
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          isOnline
                              ? Utils.getString("online")
                              : Utils.getString("offline"),
                          maxLines: 1,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: CustomColors.textTertiaryColor,
                                fontFamily: Config.manropeSemiBold,
                                fontSize: Dimens.space15.sp,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                              ),
                        )),
                    SizedBox(
                      width: Dimens.space15.w,
                    ),
                    FlutterSwitch(
                        value: isOnline,
                        width: Dimens.space52,
                        height: Dimens.space27,
                        activeColor: CustomColors.callAcceptColor,
                        onToggle: (bool value) {
                          switchStatus(value);
                        }),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: CustomColors.bottomAppBarColor,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space15.h,
                Dimens.space16.w, Dimens.space10.h),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            color: CustomColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("editProfile"),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          )
                        ],
                      ),
                      Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("accountSettings"),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          )
                        ],
                      ),
                      Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: double.infinity,
              color: CustomColors.bottomAppBarColor,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space15.h,
                  Dimens.space16.w, Dimens.space15.h),
              child: Text(
                Utils.getString("appSettings").toUpperCase(),
                style: Theme.of(context).textTheme.button.copyWith(
                    color: CustomColors.textPrimaryLightColor,
                    fontFamily: Config.manropeBold,
                    fontWeight: FontWeight.normal,
                    fontSize: Dimens.space14.sp,
                    fontStyle: FontStyle.normal),
              )),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            color: CustomColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("notifications"),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          )
                        ],
                      ),
                      Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("audio"),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textQuaternaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: Text(
                                "Voice Activity",
                                maxLines: 1,
                                softWrap: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                              )),
                          Icon(
                            CustomIcon.icon_arrow_right,
                            size: Dimens.space24.w,
                            color: CustomColors.textQuinaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("appearance"),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textQuaternaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: Text(
                                "Light",
                                maxLines: 1,
                                softWrap: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                              )),
                          Icon(
                            CustomIcon.icon_arrow_right,
                            size: Dimens.space24.w,
                            color: CustomColors.textQuinaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: CustomColors.bottomAppBarColor,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space15.h,
                Dimens.space16.w, Dimens.space10.h),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            color: CustomColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("rateKrispCall"),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textQuaternaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          )
                        ],
                      ),
                      Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("helpCenter"),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textQuaternaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          )
                        ],
                      ),
                      Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("about"),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textQuaternaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                          )
                        ],
                      ),
                      Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteWidget extends StatelessWidget {
  DeleteWidget({this.userProvider, this.onLogOut});

  final UserProvider userProvider;
  final Function onLogOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
      margin: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
      child: TextButton(
        style: TextButton.styleFrom(
          alignment: Alignment.center,
          backgroundColor: Colors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.fromLTRB(
              Dimens.space16, Dimens.space14, Dimens.space16, Dimens.space14),
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            Utils.getString('delete'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: CustomColors.callDeclineColor,
                fontFamily: Config.manropeSemiBold,
                fontSize: Dimens.space15.sp,
                fontWeight: FontWeight.normal),
          ),
        ),
        onPressed: () {
          // showDialog<dynamic>(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return ConfirmDialogView(
          //           description: Utils.getString('areYouSureToLogOut'),
          //           leftButtonText: Utils.getString('cancel'),
          //           rightButtonText: Utils.getString('ok'),
          //           onAgreeTap: () async {
          //             onLogOut();
          //           });
          //     });
        },
      ),
    );
  }
}

class LogoutWidget extends StatelessWidget {
  LogoutWidget({this.userProvider, this.onLogOut});

  final UserProvider userProvider;
  final Function onLogOut;
  WebSocketController webSocketController = WebSocketController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
      margin: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
      child: TextButton(
        style: TextButton.styleFrom(
          alignment: Alignment.center,
          backgroundColor: Colors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.fromLTRB(
              Dimens.space16, Dimens.space14, Dimens.space16, Dimens.space14),
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(
              Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
          child: Text(
            toBeginningOfSentenceCase(Utils.getString('logOut')),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: CustomColors.callDeclineColor,
                fontFamily: Config.manropeSemiBold,
                fontSize: Dimens.space15.sp,
                fontWeight: FontWeight.normal),
          ),
        ),
        onPressed: () {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description: Utils.getString('areYouSureToLogOut'),
                    leftButtonText: Utils.getString('cancel'),
                    rightButtonText: Utils.getString('ok'),
                    onAgreeTap: () async {
                      webSocketController.onClose();
                      await onLogOut();
                      Navigator.of(context).pop();
                    });
              });
        },
      ),
    );
  }
}
