import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/dialog/ContactDetailDialog.dart';
import 'package:voice_example/ui/contacts/contact_view/ContactListItemView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddContactIntentHolder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationSearchContactDialog extends StatefulWidget {
  const NavigationSearchContactDialog({
    Key key,
    @required this.animationController,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    @required this.makeCallWithSid,
  }) : super(key: key);

  final AnimationController animationController;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String, String, String, String, String) makeCallWithSid;

  @override
  NavigationSearchContactDialogState createState() => NavigationSearchContactDialogState();
}

class NavigationSearchContactDialogState extends State<NavigationSearchContactDialog>
{
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  ContactsProvider contactsProvider;
  ContactRepository contactRepository;
  final TextEditingController controllerSearchContacts = TextEditingController();
  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue)
    {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
  }

  ValueHolder valueHolder;

  @override
  void initState()
  {
    if (!isConnectedToInternet)
    {
      checkConnection();
    }
    super.initState();
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    contactRepository = Provider.of<ContactRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);


    return Container(
        height: MediaQuery.of(context).size.height.h,
        width: MediaQuery.of(context).size.width.w,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space16.r),
            topRight: Radius.circular(Dimens.space16.r),
          ),
          color: CustomColors.white,
          shape: BoxShape.rectangle,
        ),
        child: Scaffold(
          backgroundColor: CustomColors.transparent,
          resizeToAvoidBottomInset: true,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space18.h, Dimens.space20.w, Dimens.space18.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child:  Text(
                          Utils.getString("browseContacts"),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeBold,
                              fontWeight: FontWeight.normal,
                              fontSize: Dimens.space16.sp,
                              fontStyle: FontStyle.normal
                          ),
                        ),
                      ),
                      Positioned(
                        left: Dimens.space0.w,
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space24,
                          height: Dimens.space24,
                          boxFit: BoxFit.cover,
                          iconUrl: CustomIcon.icon_arrow_left,
                          iconColor: CustomColors.loadingCircleColor,
                          iconSize: Dimens.space24,
                          outerCorner: Dimens.space0,
                          innerCorner: Dimens.space0,
                          boxDecorationColor: CustomColors.transparent,
                          imageUrl: "",
                          onTap:()
                          {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  )
              ),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1.h,
                thickness: Dimens.space1.h,
              ),
              Expanded(
                  child: ChangeNotifierProvider<ContactsProvider>(
                    lazy: false,
                    create: (BuildContext context)
                    {
                      contactsProvider = ContactsProvider(contactRepository: contactRepository);
                      contactsProvider.doAllContactApiCall();
                      controllerSearchContacts.addListener(()
                      {
                        if(controllerSearchContacts.text.isEmpty)
                        {
                          contactsProvider.getAllContactsFromDB();
                        }
                        else if (controllerSearchContacts.text != null && controllerSearchContacts.text.isNotEmpty && controllerSearchContacts.text!="")
                        {
                          contactsProvider.doSearchContactFromDb(controllerSearchContacts.text);
                        }
                        else
                        {
                          contactsProvider.getAllContactsFromDB();
                        }
                      });
                      return contactsProvider;
                    },
                    child: Consumer<ContactsProvider>(builder: (BuildContext context, ContactsProvider provider, Widget child)
                    {
                      if (contactsProvider.contactResponse != null && contactsProvider.contactResponse.data != null)
                      {
                        if(contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges.isNotEmpty)
                        {
                          for (int i = 0, length = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges.length; i < length; i++)
                          {
                            String pinyin = PinyinHelper.getPinyinE(contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[i].contactNode.name!=null && contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[i].contactNode.name.isNotEmpty?contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[i].contactNode.name:Utils.getString("unknown"));
                            String tag = pinyin.substring(0, 1).toUpperCase();
                            provider.contactResponse.data.contactResponse
                                .contactResponseData.contactEdges[i].namePinyin = pinyin;
                            if (RegExp("[A-Z]").hasMatch(tag)) {
                              provider.contactResponse.data.contactResponse
                                  .contactResponseData.contactEdges[i].tagIndex = tag;
                            } else {
                              provider.contactResponse.data.contactResponse
                                  .contactResponseData.contactEdges[i].tagIndex = "#";
                            }
                          }
                          // A-Z sort.
                          SuspensionUtil.sortListBySuspensionTag(provider.contactResponse
                              .data.contactResponse.contactResponseData.contactEdges);

                          // show sus tag.
                          SuspensionUtil.setShowSuspensionStatus(provider.contactResponse
                              .data.contactResponse.contactResponseData.contactEdges);
                        }
                        return RefreshIndicator(
                          color: CustomColors.mainColor,
                          backgroundColor: CustomColors.white,
                          child: Container(
                            color: CustomColors.white,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h,),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space16.w,
                                      Dimens.space20.h,
                                      Dimens.space16.w,
                                      Dimens.space20.h),
                                  padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                                      Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  alignment: Alignment.center,
                                  child: TextField(
                                    controller: controllerSearchContacts,
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
                                      hintText: Utils.getString('searchContacts'),
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
                                contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges.isNotEmpty?
                                Expanded(
                                  child: AzListView(
                                    data: provider.contactResponse.data.contactResponse
                                        .contactResponseData.contactEdges,
                                    itemCount: provider
                                        .contactResponse
                                        .data
                                        .contactResponse
                                        .contactResponseData
                                        .contactEdges
                                        .length,
                                    susItemBuilder: (context, i)
                                    {
                                      return Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          decoration: BoxDecoration(
                                            color: CustomColors.bottomAppBarColor,
                                          ),
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width.w,
                                            padding: EdgeInsets.fromLTRB(
                                                Dimens.space20.w,
                                                Dimens.space5.h,
                                                Dimens.space20.w,
                                                Dimens.space5.h),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${provider.contactResponse.data.contactResponse.contactResponseData.contactEdges[i].getSuspensionTag()}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: CustomColors.textTertiaryColor,
                                                  fontFamily: Config.manropeBold,
                                                  fontSize: Dimens.space14.sp,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ));
                                    },
                                    itemBuilder: (BuildContext context, int index) {
                                      final int count = provider
                                          .contactResponse
                                          .data
                                          .contactResponse
                                          .contactResponseData
                                          .contactEdges
                                          .length;
                                      widget.animationController.forward();
                                      return ContactListItemView(
                                        animationController: widget.animationController,
                                        animation:
                                        Tween<double>(begin: 0.0, end: 1.0).animate(
                                          CurvedAnimation(
                                            parent: widget.animationController,
                                            curve: Interval((1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ),
                                        ),
                                        offStage: true,
                                        contactEdges: provider
                                            .contactResponse
                                            .data
                                            .contactResponse
                                            .contactResponseData
                                            .contactEdges[index],
                                        onTap: () async {
                                          await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Dimens.space16.r),
                                              ),
                                              backgroundColor: Colors.white,
                                              builder: (BuildContext context) {
                                                return ContactDetailDialog(
                                                    contactId: contactsProvider
                                                        .contactResponse
                                                        .data
                                                        .contactResponse
                                                        .contactResponseData
                                                        .contactEdges[index].contactNode.id,
                                                    contactNumber: contactsProvider
                                                        .contactResponse
                                                        .data
                                                        .contactResponse
                                                        .contactResponseData
                                                        .contactEdges[index].contactNode.number,
                                                    onContactUpdate: ()
                                                    {
                                                      provider.doAllContactApiCall();
                                                    },
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
                                      );
                                    },
                                    physics: AlwaysScrollableScrollPhysics(),
                                    indexBarData: SuspensionUtil.getTagIndexList(null),
                                    indexBarMargin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    indexBarOptions: IndexBarOptions(
                                      needRebuild: true,
                                      indexHintAlignment: Alignment.centerRight,
                                    ),
                                  ),
                                ):
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                      alignment: Alignment.center,
                                      child: SingleChildScrollView(
                                        child: EmptyViewUiWidget(
                                          assetUrl: "assets/images/empty_contact.png",
                                          title: Utils.getString('noContacts'),
                                          desc: Utils.getString('noContactsDescription'),
                                          buttonTitle: Utils.getString('addANewContact'),
                                          icon: Icons.add_circle_outline,
                                          onPressed: () async
                                          {
                                            final dynamic returnData = await Navigator.pushNamed(
                                              context,
                                              RoutePaths.newContact,
                                              arguments:AddContactIntentHolder(
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
                                            if (returnData != null && returnData["data"] is bool && returnData["data"])
                                            {
                                              contactsProvider.doAllContactApiCall();
                                            }
                                          },
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onRefresh: ()
                          {
                            return contactsProvider.doAllContactApiCall();
                          },
                        );
                      }
                      else
                      {
                        widget.animationController.forward();
                        final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                            parent: widget.animationController,
                            curve: const Interval(0.5 * 1, 1.0,
                                curve: Curves.fastOutSlowIn)));
                        return AnimatedBuilder(
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
                                ));
                          },
                        );
                      }
                    }),
                  ),
              ),
            ],
          ),
        )
    );
  }
}
