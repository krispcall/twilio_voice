import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/contacts/contact_view/ContactListItemView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactListOnlyDialog extends StatefulWidget {
  const ContactListOnlyDialog({
    Key key,
    @required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  ContactListOnlyDialogState createState() => ContactListOnlyDialogState();
}

class ContactListOnlyDialogState extends State<ContactListOnlyDialog>
{
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  ContactsProvider contactsProvider;
  ContactRepository contactRepository;

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
                          Utils.getString("contacts"),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeBold,
                              fontWeight: FontWeight.normal,
                              fontSize: Dimens.space18.sp,
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
                          iconUrl: CustomIcon.icon_close,
                          iconColor: CustomColors.iconColorBlack,
                          iconSize: Dimens.space10,
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
                      return contactsProvider;
                    },
                    child: Consumer<ContactsProvider>(builder: (BuildContext context, ContactsProvider provider, Widget child)
                    {
                      if (contactsProvider.contactResponse != null && contactsProvider.contactResponse.data != null)
                      {
                        if (contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges.isNotEmpty)
                        {
                          return Container(
                            color: CustomColors.white,
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: provider.contactResponse.data.contactResponse.contactResponseData.contactEdges.length,
                              itemBuilder: (BuildContext context, int index)
                              {
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
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: widget.animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  offStage: false,
                                  contactEdges: provider
                                      .contactResponse
                                      .data
                                      .contactResponse
                                      .contactResponseData
                                      .contactEdges[index],
                                  onTap: ()
                                  {
                                  },
                                );
                              },
                              physics: AlwaysScrollableScrollPhysics(),
                            ),
                          );
                        }
                        else
                        {
                          widget.animationController.forward();
                          final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                              parent: widget.animationController,
                              curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn))
                          );
                          return AnimatedBuilder(
                            animation: widget.animationController,
                            builder: (BuildContext context, Widget child)
                            {
                              return FadeTransition(
                                  opacity: animation,
                                  child: Transform(
                                    transform: Matrix4.translationValues(
                                        0.0, 100 * (1.0 - animation.value), 0.0),
                                    child: Container(
                                      color: CustomColors.white,
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
                                      child: EmptyViewUiWidget(
                                        assetUrl: "assets/images/empty_contact.png",
                                        title: Utils.getString('noContacts'),
                                        desc: Utils.getString('noContactsDescription'),
                                        buttonTitle: Utils.getString('addANewContact'),
                                        icon: Icons.add_circle_outline,
                                        onPressed: () {},
                                      ),
                                    ),
                                  )
                              );
                            },
                          );
                        }
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
                          builder: (BuildContext context, Widget child)
                          {
                            return FadeTransition(
                                opacity: animation,
                                child: Transform(
                                  transform: Matrix4.translationValues(
                                      0.0, 100 * (1.0 - animation.value), 0.0),
                                  child: Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                                    child: SpinKitCircle(
                                      color: CustomColors.mainColor,
                                    ),
                                  ),
                                )
                            );
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
