import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/tag/TagsVerticalItemView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddGlobalTagViewHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/TagIntentHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/ColorHolder.dart';
import 'package:provider/provider.dart';

/*
 * *
 *  * Created by Kedar on 7/12/21 12:51 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/12/21 12:51 PM
 *
 */

class TagsListView extends StatefulWidget {
  final String workspaceName;
  final String workSpaceImage;

  TagsListView({
    Key key,
    @required this.workspaceName,
    @required this.workSpaceImage,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final Function onIncomingTap;
  final Function onOutgoingTap;
  @override
  AddTagViewWidgetState createState() => AddTagViewWidgetState();
}

class AddTagViewWidgetState extends State<TagsListView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController animationController;
  TextEditingController controllerSearchTag = TextEditingController();
  ContactRepository contactRepository;
  ContactsProvider contactsProvider;
  ColorHolder selectedColor;
  List<String> selectedTags = [];
  String clientId = "";
  bool onEditingEnabled = false;

  @override
  void initState() {
    selectedColor = Config.supportColorHolder[0];
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, clientId);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    animationController.forward();

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        body: CustomAppBar<ContactsProvider>(
            titleWidget: PreferredSize(
              preferredSize:
                  Size(MediaQuery.of(context).size.width.w, kToolbarHeight.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextButton(
                          onPressed: _requestPop,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: CustomColors.transparent,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CustomIcon.icon_arrow_left,
                                color: CustomColors.loadingCircleColor,
                                size: Dimens.space22.w,
                              ),
                              Text(
                                Utils.getString('back'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: CustomColors.loadingCircleColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      Utils.getString("tags"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeBold,
                            fontSize: Dimens.space16.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    ),
                  ),
                ],
              ),
            ),
            leadingWidget: null,
            centerTitle: false,
            elevation: 1,
            onIncomingTap: ()
            {
              widget.onIncomingTap();
            },
            onOutgoingTap: ()
            {
              widget.onOutgoingTap();
            },
            initProvider: ()
            {
              return ContactsProvider(contactRepository: contactRepository);
            },
            onProviderReady: (ContactsProvider provider) async {
              contactsProvider = provider;
              contactsProvider.doContactDetailApiCall(clientId).then((value) {
                if (contactsProvider.contactDetailResponse.data != null &&
                    contactsProvider.contactDetailResponse.data
                            .contactDetailResponseData.contacts.tags !=
                        null &&
                    contactsProvider.contactDetailResponse.data
                            .contactDetailResponseData.contacts.tags.length !=
                        0) {
                  for (int i = 0;
                      i <
                          contactsProvider.contactDetailResponse.data
                              .contactDetailResponseData.contacts.tags.length;
                      i++) {
                    setState(() {
                      selectedTags.add(contactsProvider.contactDetailResponse
                          .data.contactDetailResponseData.contacts.tags[i].id);
                    });
                  }
                }
                contactsProvider.doGetAllTagsApiCall();
              });
              controllerSearchTag.addListener(() {
                if (controllerSearchTag.text != null &&
                    controllerSearchTag.text.isNotEmpty) {
                  onEditingEnabled = true;
                  contactsProvider.doDbTagSearch(controllerSearchTag.text);
                } else {
                  onEditingEnabled = false;
                  contactsProvider.doGetTagsFromDb();
                }
              });
            },
            builder: (BuildContext context, ContactsProvider provider,
                Widget child) {
              if (contactsProvider.tags != null &&
                  contactsProvider.tags.data != null) {
                return RefreshIndicator(
                  color: CustomColors.mainColor,
                  backgroundColor: CustomColors.white,
                  child: Container(
                    color: CustomColors.white,
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.fromLTRB(
                        Dimens.space0.w,
                        Dimens.space0.h,
                        Dimens.space0.w,
                        (kBottomNavigationBarHeight + Dimens.space10).h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space16.w,
                              Dimens.space20.h,
                              Dimens.space16.w,
                              Dimens.space20.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: controllerSearchTag,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textSenaryColor,
                                    fontFamily: Config.manropeMedium,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space14.sp,
                                    fontStyle: FontStyle.normal),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space13.h,
                                  Dimens.space0.w,
                                  Dimens.space13.h),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: Dimens.space0.w,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space10.r)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: Dimens.space0.w,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space10.r)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: Dimens.space0.w,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space10.r)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: Dimens.space0.w,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space10.r)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: Dimens.space0.w,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space10.r)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: Dimens.space0.w,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space10.r)),
                              ),
                              filled: true,
                              fillColor: CustomColors.baseLightColor,
                              prefixIcon: Icon(
                                CustomIcon.icon_search,
                                size: Dimens.space16.w,
                                color: CustomColors.textTertiaryColor,
                              ),
                              hintText: Utils.getString('searchTags'),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: CustomColors.textSenaryColor,
                                      fontFamily: Config.manropeMedium,
                                      fontWeight: FontWeight.normal,
                                      fontSize: Dimens.space14.sp,
                                      fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                        Divider(
                          color: CustomColors.mainDividerColor,
                          height: 0.8,
                          thickness: Dimens.space1,
                        ),
                        contactsProvider.tags.data.isNotEmpty
                            ? Expanded(
                                child: Container(
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
                                alignment: Alignment.center,
                                child: MediaQuery.removePadding(
                                    context: context,
                                    child: ListView.builder(
                                        itemCount:
                                            contactsProvider.tags.data.length,
                                        itemBuilder: (context, index) {
                                          return TagsVerticalItemView(
                                            tag: contactsProvider
                                                .tags.data[index],
                                            animationController:
                                                animationController,
                                            animation: Tween<double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(
                                              CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 /
                                                            contactsProvider
                                                                .tags
                                                                .data
                                                                .length) *
                                                        index,
                                                    1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            onTap: ()
                                            {

                                              Navigator.pushNamed(
                                                context,
                                                RoutePaths.algebra,
                                                arguments: TagsIntentHolder(
                                                    tag: contactsProvider
                                                        .tags.data[index],
                                                    onCallBack: () {
                                                      contactsProvider
                                                          .doGetAllTagsApiCall();
                                                    },
                                                  onIncomingTap: ()
                                                  {
                                                    widget.onIncomingTap();
                                                  },
                                                  onOutgoingTap: ()
                                                  {
                                                    widget.onOutgoingTap();
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        })),
                              ))
                            : (onEditingEnabled
                                ? Expanded(
                                    child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space20.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: Column(
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              alignment: Alignment.centerLeft,
                                              side: BorderSide(
                                                width: Dimens.space1.h,
                                                color: CustomColors
                                                    .mainDividerColor,
                                              )),
                                          onPressed: () async {

                                            Navigator.pushNamed(context,
                                                RoutePaths.addGlobalTag,
                                                arguments:
                                                    AddGlobalTagViewHolder(
                                                  workspaceName:
                                                      widget.workspaceName,
                                                  workspaceImage:
                                                      widget.workSpaceImage,
                                                      onIncomingTap: ()
                                                      {
                                                        widget.onIncomingTap();
                                                      },
                                                      onOutgoingTap: ()
                                                      {
                                                        widget.onOutgoingTap();
                                                      },
                                                      onCallBack: (){
                                                        contactsProvider.doGetAllTagsApiCall();
                                                      }
                                                ));
                                          },
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space20.w,
                                                  Dimens.space12.h,
                                                  Dimens.space20.w,
                                                  Dimens.space12.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              height: Dimens.space52.h,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            Dimens.space0.w,
                                                            Dimens.space0.h,
                                                            Dimens.space0.w,
                                                            Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.add_circle_outline,
                                                      color: CustomColors
                                                          .loadingCircleColor,
                                                      size: Dimens.space20.w,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                    width: double.infinity,
                                                    height: Dimens.space50.h,
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space10.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        '${Utils.getString('addNewTag')}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .copyWith(
                                                              fontFamily: Config
                                                                  .heeboMedium,
                                                              color: CustomColors
                                                                  .loadingCircleColor,
                                                              fontSize: Dimens
                                                                  .space16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                            )),
                                                  )),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ))
                                : Expanded(
                                    child: Container(
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
                                        alignment: Alignment.center,
                                        child: SingleChildScrollView(
                                          child: EmptyViewUiWidget(
                                            assetUrl:
                                                "assets/images/empty_tags.png",
                                            title: Utils.getString('noTags'),
                                            desc: Utils.getString('noTagDesc'),
                                            buttonTitle:
                                                Utils.getString('createTag'),
                                            icon: Icons.add_circle_outline,
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                  RoutePaths.addGlobalTag,
                                                  arguments:
                                                      AddGlobalTagViewHolder(
                                                    workspaceName:
                                                        widget.workspaceName,
                                                    workspaceImage:
                                                        widget.workSpaceImage,
                                                        onIncomingTap: ()
                                                        {
                                                          widget.onIncomingTap();
                                                        },
                                                        onOutgoingTap: ()
                                                        {
                                                          widget.onOutgoingTap();
                                                        },
                                                        onCallBack: (){
                                                          contactsProvider
                                                              .doGetAllTagsApiCall();
                                                        }
                                                  ));
                                            },
                                          ),
                                        )),
                                  ))
                      ],
                    ),
                  ),
                  onRefresh: () {
                    return contactsProvider.doGetAllTagsApiCall();
                  },
                );
              } else {
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
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(Dimens.space0,
                                Dimens.space0, Dimens.space0, Dimens.space0),
                            child: SpinKitCircle(
                              color: CustomColors.mainColor,
                            ),
                          ),
                        ));
                  },
                );
              }
            }),
      ),
    );
  }
}
