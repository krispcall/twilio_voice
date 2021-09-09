import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/provider/messages/MessageDetailsProvider.dart';
import 'package:voice_example/repository/MessageDetailsRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/DateTimeTextWidget.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

class ConversationSearchView extends StatefulWidget {
  final String contactNumber;
  final String contactName;
  final AnimationController animationController;

  const ConversationSearchView(
      {Key key, this.contactNumber, this.contactName, this.animationController})
      : super(key: key);
  @override
  _ConversationSearchViewState createState() => _ConversationSearchViewState();
}

class _ConversationSearchViewState extends State<ConversationSearchView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  Animation<double> animation;
  bool isConnectedToInternet = false;
  MessageDetailsProvider messagesProvider;
  MessageDetailsRepository messagesRepository;
 Resources<List<RecentConversationEdges>> response ;
  bool isFirstTime = true;

  @override
  void initState()
  {
    checkConnection();
    animationController = AnimationController(duration: Config.animation_duration, vsync: this);
    animationController.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    super.initState();
  }

  onSubmitData(String keyword) async {
    _isSearching = true;
    setState(() {});
    response = await messagesProvider.doSearchConversationApiCall(
        widget.contactNumber, keyword);
    _isSearching = false;
    isFirstTime = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    messagesRepository = Provider.of<MessageDetailsRepository>(context);

    return ChangeNotifierProvider(
      lazy: false,
      create: (BuildContext context) {
        this.messagesProvider = MessageDetailsProvider(
            messageDetailsRepository: messagesRepository);

        return messagesProvider;
      },
      child: Scaffold(
        backgroundColor: CustomColors.mainBackgroundColor,
        appBar: AppBar(
          backgroundColor: CustomColors.white,
          elevation: 0.5,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Icon(
                  CustomIcon.icon_arrow_left,
                  color: CustomColors.loadingCircleColor,
                  size: Dimens.space22.w,
                ),
              ),
            ),
          ),
          title: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: CustomSearchTextField(
              prefix: true,
              height: Dimens.space54.h,
              isForCountry: false,
              showTitle: false,
              showSubTitle: false,
              containerFillColor: CustomColors.baseLightColor,
              borderColor: CustomColors.secondaryColor,
              corner: Dimens.space10,
              titleFont: Config.manropeBold,
              titleTextColor: CustomColors.textSecondaryColor,
              titleFontSize: Dimens.space14,
              titleFontStyle: FontStyle.normal,
              titleFontWeight: FontWeight.w700,
              titleMarginLeft: Dimens.space0,
              titleMarginRight: Dimens.space0,
              titleMarginBottom: Dimens.space6,
              titleMarginTop: Dimens.space0,
              hintText: Utils.getString("searchConversation"),
              hintFontColor: CustomColors.textQuaternaryColor,
              hintFontFamily: Config.heeboRegular,
              hintFontSize: Dimens.space16,
              hintFontStyle: FontStyle.normal,
              hintFontWeight: FontWeight.normal,
              inputFontColor: CustomColors.textQuaternaryColor,
              inputFontFamily: Config.heeboRegular,
              inputFontSize: Dimens.space16,
              inputFontStyle: FontStyle.normal,
              inputFontWeight: FontWeight.normal,
              textEditingController: _searchQueryController,
              autoFocus: true,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.search,
              onSubmit: (keyword) {
                onSubmitData(keyword);
              },
            ),
          ),
        ),
        body: _isSearching
            ? Center(
                child: AnimatedBuilder(
                animation: widget.animationController,
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
                    ),
                  );
                },
              ))
            : Container(
                child: isFirstTime
                    ? Center(
                        child: Container(
                          color: Colors.white,
                          height: Utils.getScreenHeight(context),
                          width: Utils.getScreenWidth(context),
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
                              child: EmptyViewUiWidget(
                                assetUrl: "assets/images/no_conversation.png",
                                title: Utils.getString('searchConversation'),
                                desc: Utils.getString(''),
                                buttonTitle:
                                    Utils.getString('startConversation'),
                                icon: Icons.add_circle_outline,
                                showButton: false,
                              )),
                        ),
                      )
                    : response.status == Status.ERROR
                        ? Container(
                            color: Colors.white,
                            height: Utils.getScreenHeight(context),
                            width: Utils.getScreenWidth(context),
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
                                child: EmptyViewUiWidget(
                                  assetUrl: "assets/images/no_conversation.png",
                                  title: Utils.getString('serverError'),
                                  desc: Utils.getString(''),
                                  buttonTitle: Utils.getString('startConversation'),
                                  icon: Icons.add_circle_outline,
                                  showButton: false,
                                )),
                          )
                        :response.status == Status.SUCCESS && response.data?.length != 0? ListView.builder(
                            itemCount: response.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
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
                                width: MediaQuery.of(context).size.width.w,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: CustomColors.mainDividerColor,
                                      width: Dimens.space1.h,
                                    ),
                                  ),
                                ),
                                child: ConversationSearchWidget(
                                  searchText: _searchQueryController.text,
                                  name: widget.contactName ?? "",
                                  keyword: response.data[index]
                                          ?.recentConversationNodes
                                          ?.content
                                          ?.body ??
                                      "",
                                  imageUrl: response.data[index]
                                          ?.recentConversationNodes
                                          ?.clientProfilePicture ??
                                      "",
                                  flagUrl: response.data[index]
                                          ?.recentConversationNodes
                                          ?.clientCountryFlag ??
                                      "",
                                  onPressed: () {
                                    Navigator.of(context).pop({
                                      'data': true,
                                      'beforeWith': messagesRepository
                                          .pageInfo.startCursor,
                                      'afterWith': response.data[index].cursor
                                    });
                                    // Navigator.of(context).pop({'data': true, 'cursor': response[index].cursor});
                                  },
                                  date: response.data[index]
                                          ?.recentConversationNodes
                                          ?.createdAt ??
                                      "",
                                  timestamp: "",
                                ),
                              );
                            }):Container(
                  color: Colors.white,
                  height: Utils.getScreenHeight(context),
                  width: Utils.getScreenWidth(context),
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
                      child: EmptyViewUiWidget(
                        assetUrl: "assets/images/no_conversation.png",
                        title: Utils.getString('noSearchResults'),
                        desc: Utils.getString(''),
                        buttonTitle:
                        Utils.getString('startConversation'),
                        icon: Icons.add_circle_outline,
                        showButton: false,
                      )),
                ),
              ),
      ),
    );
  }

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
  }
}

class ConversationSearchWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String flagUrl;
  final Function onPressed;
  final String date;
  final String timestamp;
  final String keyword;
  final String searchText;

  const ConversationSearchWidget(
      {Key key,
      this.name,
      this.imageUrl,
      this.flagUrl,
      this.onPressed,
      this.date,
      this.timestamp,
      this.keyword,
      this.searchText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: CustomColors.mainBackgroundColor,
            padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h,
                Dimens.space20.w, Dimens.space10.h),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: Dimens.space48.w,
                height: Dimens.space48.w,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space48,
                  height: Dimens.space48,
                  boxFit: BoxFit.cover,
                  containerAlignment: Alignment.bottomCenter,
                  iconUrl: CustomIcon.icon_profile,
                  iconColor: CustomColors.callInactiveColor,
                  iconSize: Dimens.space40,
                  boxDecorationColor: CustomColors.mainDividerColor,
                  outerCorner: Dimens.space16,
                  innerCorner: Dimens.space16,
                  imageUrl: imageUrl,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child:

                              Text(
                                name,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                              )
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space6.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: RoundedNetworkSvgHolder(
                              containerWidth: Dimens.space16,
                              containerHeight: Dimens.space16,
                              boxFit: BoxFit.contain,
                              imageWidth: Dimens.space16,
                              imageHeight: Dimens.space16,
                              outerCorner: Dimens.space0,
                              innerCorner: Dimens.space0,
                              iconUrl: CustomIcon.icon_person,
                              iconColor: CustomColors.white,
                              iconSize: Dimens.space16,
                              boxDecorationColor: Colors.transparent,
                              imageUrl: Config.countryLogoUrl + flagUrl,
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(Dimens.space0,
                              Dimens.space0, Dimens.space0, Dimens.space0),
                          child:SubstringHighlight(
                            text: keyword,                         // each string needing highlighting
                            term: searchText,                           // user typed "m4a"
                            overflow: TextOverflow.ellipsis,
                            textStyleHighlight: TextStyle(              // highlight style
                              color: CustomColors.textPrimaryColor,
                              decoration: TextDecoration.underline,
                            ),
                            textStyle: Theme.of(context).textTheme.button.copyWith(
                                      color: CustomColors.textPrimaryLightColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Container(
                        //   alignment: Alignment.center,
                        //   margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        //   padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        //   child: Offstage(
                        //     offstage: callLog.recentConversationNodes.contactPinned!=null && callLog.recentConversationNodes.contactPinned?false:true,
                        //     child: RoundedNetworkImageHolder(
                        //       width: Dimens.space18,
                        //       height: Dimens.space18,
                        //       boxFit: BoxFit.cover,
                        //       iconUrl: CustomIcon.icon_pin,
                        //       iconColor: CustomColors.warningColor,
                        //       iconSize: Dimens.space12,
                        //       outerCorner: Dimens.space0,
                        //       innerCorner: Dimens.space0,
                        //       boxDecorationColor:
                        //       CustomColors.transparent,
                        //       imageUrl: "",
                        //     ),
                        //   ),
                        // ),
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
                            child: DateTimeTextWidget(
                              timestamp: timestamp,
                              date: date,
                              format: DateFormat('yyyy-MM-ddThh:mm:ss.SSSSSS'),
                              dateFontColor: CustomColors.textQuinaryColor,
                              dateFontFamily: Config.manropeSemiBold,
                              dateFontSize: Dimens.space13,
                              dateFontStyle: FontStyle.normal,
                              dateFontWeight: FontWeight.normal,
                            )),
                      ],
                    ),
                    Container(height: Dimens.space15.h),
                    // Container(
                    //     width: Dimens.space10.w,
                    //     height: Dimens.space10.h,
                    //     margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                    //         Dimens.space12.h, Dimens.space0.w, Dimens.space0.h),
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: CustomColors.textPrimaryErrorColor,
                    //       shape: BoxShape.rectangle,
                    //       borderRadius: BorderRadius.all(
                    //           Radius.circular(Dimens.space5.r)),
                    //     ))
                  ],
                ),
              ),
            ],
          ),
          onPressed: () {
            onPressed();
          },
        ));
  }
}
