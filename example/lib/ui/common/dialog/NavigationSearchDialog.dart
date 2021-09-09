import 'package:flutter/cupertino.dart';
import 'package:voice_example/config/Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/provider/memberProvider/MemberProvider.dart';
import 'package:voice_example/provider/recentSearch/RecentSearchProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/repository/MemberRepository.dart';
import 'package:voice_example/repository/RecentSearchRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/RecentSearchItemWidget.dart';
import 'package:voice_example/ui/common/dialog/NavigationSearchContactDialog.dart';
import 'package:voice_example/ui/common/dialog/NavigationSearchMemberDialog.dart';
import 'package:voice_example/ui/contacts/contact_view/ContactListItemView.dart';
import 'package:voice_example/ui/members/MemberListItemView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/recentSearch/RecentSearch.dart';
import 'package:provider/provider.dart';

class NavigationSearchDialog extends StatefulWidget
{
  const NavigationSearchDialog({
    Key key,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    @required this.makeCallWithSid,
  }) :super(key: key);

  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String, String, String, String, String) makeCallWithSid;

  @override
  NavigationSearchDialogState createState() => NavigationSearchDialogState();
}

class NavigationSearchDialogState extends State<NavigationSearchDialog> with SingleTickerProviderStateMixin
{
  AnimationController animationController;
  final TextEditingController controllerSearch = TextEditingController();

  RecentSearchRepository recentSearchRepository;
  RecentSearchProvider recentSearchProvider;

  ContactRepository contactRepository;
  ContactsProvider contactsProvider;

  // CallLogRepository callLogRepository;
  // CallLogProvider callLogProvider;

  MemberRepository memberRepository;
  MemberProvider memberProvider;

  String query = "";
  @override
  void initState()
  {
    animationController = AnimationController(duration: Config.animation_duration, vsync: this);
    recentSearchRepository = Provider.of<RecentSearchRepository>(context, listen: false);
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    // callLogRepository = Provider.of<CallLogRepository>(context, listen: false);
    memberRepository = Provider.of<MemberRepository>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecentSearchProvider>(
          lazy: false,
          create: (BuildContext context)
          {
            recentSearchProvider = RecentSearchProvider(recentSearchRepository: recentSearchRepository);
            recentSearchProvider.getRecentSearchListFromDb();
            return recentSearchProvider;
          },
        ),
        ChangeNotifierProvider<ContactsProvider>(
          lazy: false,
          create: (BuildContext context)
          {
            contactsProvider = ContactsProvider(contactRepository: contactRepository);
            contactsProvider.doAllContactApiCall();
            return contactsProvider;
          },
        ),
        // ChangeNotifierProvider<CallLogProvider>(
        //   lazy: false,
        //   create: (BuildContext context)
        //   {
        //     callLogProvider = CallLogProvider(callLogRepository: callLogRepository);
        //     callLogProvider.doCallLogsSmsOnlyApiCall("all");
        //     return callLogProvider;
        //   },
        // ),
        ChangeNotifierProvider<MemberProvider>(
          lazy: false,
          create: (BuildContext context)
          {
            memberProvider = MemberProvider(memberRepository: memberRepository);
            memberProvider.doGetAllWorkspaceMembersApiCall();
            return memberProvider;
          },
        ),
      ],
      child: Consumer<RecentSearchProvider>(builder: (BuildContext context, RecentSearchProvider provider, Widget child)
      {
        return Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space22.h, Dimens.space0.w, Dimens.space0.h),
            height: MediaQuery.of(context).size.height.h,
            width: MediaQuery.of(context).size.width.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space16.r),
                topRight: Radius.circular(Dimens.space16.r),
              ),
              color: CustomColors.white,
            ),
            child: SingleChildScrollView(
                child:Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                  [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextField(
                        controller: controllerSearch,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
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
                          hintText: Utils.getString('searchMembersAndContact'),
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
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (submittedQuery) async
                        {
                          if(submittedQuery!=null && submittedQuery.isNotEmpty)
                          {
                            await contactsProvider.doSearchContactFromDb(submittedQuery);
                            // await callLogProvider.doCallLogsSearchFromDb(submittedQuery);
                            await memberProvider.doSearchMemberFromDb(submittedQuery);
                            RecentSearch recentSearch = RecentSearch(recentSearch: submittedQuery);
                            recentSearchProvider.addRecentSearchToDb(recentSearch);
                            this.query = submittedQuery;
                          }
                          else
                          {
                            this.query = "";
                          }
                          setState(() {});
                        },
                      ),
                    ),

                    query!=null && query.isEmpty?
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space18.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () async
                          {
                            await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Dimens.space16.r),
                                ),
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return NavigationSearchContactDialog(
                                    animationController: animationController,
                                    onIncomingTap: ()
                                    {
                                      widget.onIncomingTap();
                                    },
                                    onOutgoingTap: ()
                                    {
                                      widget.onOutgoingTap();
                                    },
                                    makeCallWithSid: (channelNumber, channelName, channelSid, channelFlagUrl, outgoingNumber, workspaceSid, memberId, voiceToken, outgoingName, outgoingId, outgoingFlagUrl, outgoingProfilePicture)
                                    {
                                      widget.makeCallWithSid(channelNumber, channelName, channelSid, channelFlagUrl, outgoingNumber, workspaceSid, memberId, voiceToken, outgoingName, outgoingId, outgoingFlagUrl, outgoingProfilePicture);
                                    },
                                  );
                                });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:
                            [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: RoundedNetworkImageHolder(
                                  width: Dimens.space16,
                                  height: Dimens.space16,
                                  boxFit: BoxFit.cover,
                                  iconUrl: CustomIcon.icon_contacts_book,
                                  containerAlignment: Alignment.bottomCenter,
                                  iconColor: CustomColors.textTertiaryColor,
                                  iconSize: Dimens.space16,
                                  boxDecorationColor: CustomColors.transparent,
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  imageUrl: "",
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(Dimens.space15.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  child: Text(
                                    Utils.getString("browseContacts"),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.textPrimaryColor,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: RoundedNetworkImageHolder(
                                  width: Dimens.space16,
                                  height: Dimens.space16,
                                  boxFit: BoxFit.cover,
                                  iconUrl: CustomIcon.icon_arrow_right,
                                  containerAlignment: Alignment.bottomCenter,
                                  iconColor: CustomColors.textQuinaryColor,
                                  iconSize: Dimens.space16,
                                  boxDecorationColor: CustomColors.transparent,
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  imageUrl: "",
                                ),
                              ),
                            ],
                          )
                      ),
                    ):Container(),

                    query!=null && query.isEmpty?
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () async
                          {
                            await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Dimens.space16.r),
                                ),
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return NavigationSearchMemberDialog(
                                    animationController: animationController,
                                  );
                                });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:
                            [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: RoundedNetworkImageHolder(
                                  width: Dimens.space16,
                                  height: Dimens.space16,
                                  boxFit: BoxFit.cover,
                                  iconUrl: CustomIcon.icon_book,
                                  containerAlignment: Alignment.bottomCenter,
                                  iconColor: CustomColors.textTertiaryColor,
                                  iconSize: Dimens.space16,
                                  boxDecorationColor: CustomColors.transparent,
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  imageUrl: "",
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(Dimens.space15.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  child: Text(
                                    Utils.getString("browseMembers"),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.textPrimaryColor,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: RoundedNetworkImageHolder(
                                  width: Dimens.space16,
                                  height: Dimens.space16,
                                  boxFit: BoxFit.cover,
                                  iconUrl: CustomIcon.icon_arrow_right,
                                  containerAlignment: Alignment.bottomCenter,
                                  iconColor: CustomColors.textQuinaryColor,
                                  iconSize: Dimens.space16,
                                  boxDecorationColor: CustomColors.transparent,
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  imageUrl: "",
                                ),
                              ),
                            ],
                          )
                      ),
                    ):Container(),

                    query!=null && query.isEmpty?
                    Divider(
                      color: CustomColors.mainDividerColor,
                      height: Dimens.space1.h,
                      thickness: Dimens.space1.h,
                    ):Container(),

                    query!=null && query.isEmpty?
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space15.h, Dimens.space16.w, Dimens.space15.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                          [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: Text(
                                  Utils.getString("recentSearches"),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                      color: CustomColors.textSecondaryColor,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: TextButton(
                                  onPressed: () async
                                  {
                                    await recentSearchProvider.removeAllRecentSearchFromDb();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.centerRight,
                                  ),
                                  child: Text(
                                    Utils.getString("clearAll"),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.loadingCircleColor,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ):
                    Container(),

                    query!=null && query.isEmpty && recentSearchProvider.recentSearch.data!=null && recentSearchProvider.recentSearch.data.isNotEmpty!=null && recentSearchProvider.recentSearch.data.length!=0?
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recentSearchProvider.recentSearch.data.length>6?6:recentSearchProvider.recentSearch.data.length,
                        itemBuilder: (context, position)
                        {
                          return RecentSearchItemWidget(
                            recentSearch: recentSearchProvider.recentSearch.data[position],
                            onItemTap: (submittedQuery) async
                            {
                              if(submittedQuery!=null && submittedQuery.isNotEmpty)
                              {
                                await contactsProvider.doSearchContactFromDb(submittedQuery);
                                // await callLogProvider.doCallLogsSearchFromDb(submittedQuery);
                                await memberProvider.doSearchMemberFromDb(submittedQuery);
                                RecentSearch recentSearch = RecentSearch(recentSearch: submittedQuery);
                                recentSearchProvider.addRecentSearchToDb(recentSearch);
                                this.query = submittedQuery;
                              }
                              else
                              {
                                this.query = "";
                              }
                              controllerSearch.text = submittedQuery;
                              setState(() {});
                            },
                            onClearTap: () async
                            {
                              await recentSearchProvider.removeSearchKeywordFromDb(recentSearchProvider.recentSearch.data[position]);
                            },
                          );
                        },
                      ),
                    ):
                    query!=null && query.isEmpty?
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      width: MediaQuery.of(context).size.width.w,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Utils.getString("noRecentSearches"),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          color: CustomColors.textSenaryColor,
                          fontFamily: Config.manropeSemiBold,
                          fontSize: Dimens.space16.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ):
                    Container(),

                    //Call Logs Search
                    // query!=null && query.isNotEmpty?
                    // Container(
                    //     alignment: Alignment.center,
                    //     margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
                    //     padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                    //     color: CustomColors.bottomAppBarColor,
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.max,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children:
                    //       [
                    //         Expanded(
                    //           child: Container(
                    //             alignment: Alignment.centerLeft,
                    //             margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //             padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //             child: Text(
                    //               Utils.getString("recentConversation").toUpperCase(),
                    //               maxLines: 1,
                    //               textAlign: TextAlign.left,
                    //               overflow: TextOverflow.ellipsis,
                    //               style: Theme.of(context)
                    //                   .textTheme
                    //                   .bodyText1
                    //                   .copyWith(
                    //                   color: CustomColors.textTertiaryColor,
                    //                   fontStyle: FontStyle.normal,
                    //                   fontFamily: Config.manropeBold,
                    //                   fontSize: Dimens.space14.sp,
                    //                   fontWeight: FontWeight.normal
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         Expanded(
                    //           child: Container(
                    //             alignment: Alignment.centerRight,
                    //             margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //             padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //             child: TextButton(
                    //               onPressed: () async
                    //               {
                    //                 await showModalBottomSheet(
                    //                     context: context,
                    //                     isScrollControlled: true,
                    //                     shape: RoundedRectangleBorder(
                    //                       borderRadius: BorderRadius.circular(Dimens.space16.r),
                    //                     ),
                    //                     backgroundColor: Colors.transparent,
                    //                     builder: (BuildContext context) {
                    //                       return NavigationSearchCallLogDialog(
                    //                         animationController: animationController,
                    //                       );
                    //                     });
                    //               },
                    //               style: TextButton.styleFrom(
                    //                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //                 alignment: Alignment.centerRight,
                    //               ),
                    //               child: Text(
                    //                 Utils.getString("seeAll"),
                    //                 maxLines: 1,
                    //                 textAlign: TextAlign.left,
                    //                 overflow: TextOverflow.ellipsis,
                    //                 style: Theme.of(context)
                    //                     .textTheme
                    //                     .bodyText1
                    //                     .copyWith(
                    //                     color: CustomColors.loadingCircleColor,
                    //                     fontStyle: FontStyle.normal,
                    //                     fontFamily: Config.manropeSemiBold,
                    //                     fontSize: Dimens.space14.sp,
                    //                     fontWeight: FontWeight.normal
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     )
                    // ):
                    // Container(),


                    // query!=null && query.isNotEmpty && callLogProvider.callLogs!=null && callLogProvider.callLogs.data!=null && callLogProvider.callLogs.data.length!=0?
                    // Container(
                    //     alignment: Alignment.center,
                    //     margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //     padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //     child: ListView.builder(
                    //       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //       physics: NeverScrollableScrollPhysics(),
                    //       scrollDirection: Axis.vertical,
                    //       shrinkWrap: true,
                    //       itemCount: callLogProvider.callLogs.data.length>6?6:callLogProvider.callLogs.data.length,
                    //       itemBuilder: (context, position)
                    //       {
                    //         return Container(
                    //           alignment: Alignment.center,
                    //           margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //           padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space12.h, Dimens.space20.w, Dimens.space16.h),
                    //           width: MediaQuery.of(context).size.width.w,
                    //           decoration: BoxDecoration(
                    //             border: Border(
                    //               bottom: BorderSide(
                    //                 color: CustomColors.mainDividerColor,
                    //                 width: Dimens.space1.h,
                    //               ),
                    //             ),
                    //           ),
                    //           child: CallLogImageAndTextSearchWidget(
                    //             callLog: callLogProvider.callLogs.data[position],
                    //             onPressed: ()
                    //             {
                    //
                    //             },
                    //           ),
                    //         );
                    //       },
                    //     )
                    // ):
                    // query!=null && query.isNotEmpty?
                    // Container(
                    //   margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                    //   padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    //   width: MediaQuery.of(context).size.width.w,
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     Utils.getString("noCallLogs"),
                    //     overflow: TextOverflow.ellipsis,
                    //     softWrap: true,
                    //     maxLines: 1,
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .bodyText1
                    //         .copyWith(
                    //       color: CustomColors.textSenaryColor,
                    //       fontFamily: Config.manropeSemiBold,
                    //       fontSize: Dimens.space16.sp,
                    //       fontWeight: FontWeight.normal,
                    //       fontStyle: FontStyle.normal,
                    //     ),
                    //   ),
                    // ):
                    // Container(),
                    //Call Log Search UI end

                    //Member Search
                    query!=null && query.isNotEmpty?
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                        color: CustomColors.bottomAppBarColor,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                          [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: Text(
                                  Utils.getString("members").toUpperCase(),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: TextButton(
                                  onPressed: () async
                                  {
                                    await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(Dimens.space16.r),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return NavigationSearchMemberDialog(
                                            animationController: animationController,
                                          );
                                        });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.centerRight,
                                  ),
                                  child: Text(
                                    Utils.getString("seeAll"),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.loadingCircleColor,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ):
                    Container(),


                    query!=null && query.isNotEmpty && memberProvider.memberEdges!=null && memberProvider.memberEdges.data!=null && memberProvider.memberEdges.data.length!=0?
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: memberProvider.memberEdges.data.length,
                          itemBuilder: (context, position)
                          {
                            return Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space12.h, Dimens.space20.w, Dimens.space16.h),
                              width: MediaQuery.of(context).size.width.w,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: CustomColors.mainDividerColor,
                                    width: Dimens.space1.h,
                                  ),
                                ),
                              ),
                              child: MemberListSearchItemWidget(
                                memberEdges: memberProvider.memberEdges.data[position],
                                animationController: animationController,
                                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / memberProvider.memberEdges.data.length) * 1, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                    ):
                    query!=null && query.isNotEmpty?
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      width: MediaQuery.of(context).size.width.w,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Utils.getString("noMembersFound"),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          color: CustomColors.textSenaryColor,
                          fontFamily: Config.manropeSemiBold,
                          fontSize: Dimens.space16.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ):
                    Container(),
                    //Member Search UI end

                    //Contact Search UI
                    query!=null && query.isNotEmpty?
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                        color: CustomColors.bottomAppBarColor,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                          [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: Text(
                                  Utils.getString("contacts").toUpperCase(),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: TextButton(
                                  onPressed: () async
                                  {
                                    await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(Dimens.space16.r),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return NavigationSearchContactDialog(
                                            animationController: animationController,
                                            onIncomingTap: ()
                                            {
                                              widget.onIncomingTap();
                                            },
                                            onOutgoingTap: ()
                                            {
                                              widget.onOutgoingTap();
                                            },
                                            makeCallWithSid: (channelNumber, channelName, channelSid, channelFlagUrl, outgoingNumber, workspaceSid, memberId, voiceToken, outgoingName, outgoingId, outgoingFlagUrl, outgoingProfilePicture)
                                            {
                                              widget.makeCallWithSid(channelNumber, channelName, channelSid, channelFlagUrl, outgoingNumber, workspaceSid, memberId, voiceToken, outgoingName, outgoingId, outgoingFlagUrl, outgoingProfilePicture);
                                            },
                                          );
                                        });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.centerRight,
                                  ),
                                  child: Text(
                                    Utils.getString("seeAll"),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.loadingCircleColor,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ):
                    Container(),

                    query!=null && query.isNotEmpty && contactsProvider.contactResponse!=null && contactsProvider.contactResponse.data!=null && contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges.length!=0?
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges.length>6?6:contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges.length,
                          itemBuilder: (context, position)
                          {
                            return Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              width: MediaQuery.of(context).size.width.w,
                              child: ContactListItemWidget(
                                contactEdges: contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[position],
                                offStage: true,
                              ),
                            );
                          },
                        )
                    ):
                    query!=null && query.isNotEmpty?
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space15.h),
                      width: MediaQuery.of(context).size.width.w,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Utils.getString("noContactsFound"),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          color: CustomColors.textSenaryColor,
                          fontFamily: Config.manropeSemiBold,
                          fontSize: Dimens.space16.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ):
                    Container(),
                    //Contact search Ui end
                  ],
                )
            )
        );
      })
    );
  }
}
