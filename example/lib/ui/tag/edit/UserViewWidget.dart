import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/provider/country/CountryListProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/ui/dashboard/DashboardView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'UserVerticalListViewItem.dart';

class UserListViewWidget extends StatefulWidget {
  final Tags tag;

  const UserListViewWidget({
    Key key,
    this.tag,
  }) : super(key: key);

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListViewWidget>
    with SingleTickerProviderStateMixin {
  ContactRepository contactRepository;
  ContactsProvider contactsProvider;
  CountryRepository countryRepository;
  CountryListProvider countryListProvider;

  AnimationController animationController;

  ValueHolder valueHolder;

  bool isConnectedToInternet = false;
  bool isLoading = false;

  final TextEditingController controllerSearchContacts =
      TextEditingController();

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {}
    });
  }

  @override
  void initState() {
    animationController = new AnimationController(
        vsync: this, duration: Config.animation_duration);
    if (!isConnectedToInternet) {
      checkConnection();
    }
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      DashboardView.ebTransferData.on().listen((event) {
        contactsProvider.doAllContactApiCall();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    contactRepository = Provider.of<ContactRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomColors.mainBackgroundColor,
        body: ChangeNotifierProvider<ContactsProvider>(
            lazy: false,
            create: (BuildContext context) {
              this.contactsProvider =
                  ContactsProvider(contactRepository: contactRepository);
              this.contactsProvider.doFilterApiContactByTagApiCall(widget.tag.id);
              return contactsProvider;
            },
            child: Consumer<ContactsProvider>(builder: (BuildContext context,
                ContactsProvider provider, Widget child) {

              if (contactsProvider.contactResponse != null &&
                  contactsProvider.contactResponse.data != null) {
                    return RefreshIndicator(
                  color: CustomColors.mainColor,
                  child: Container(
                    color: CustomColors.mainBackgroundColor,
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(
                        Dimens.space0.w,
                        Dimens.space0.h,
                        Dimens.space0.w,
                        (kBottomNavigationBarHeight + Dimens.space10).h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: ListView.separated(
                        separatorBuilder: (context,index){
                          return Divider(
                            color: CustomColors.mainDividerColor,
                            height: 0.8,
                            thickness: Dimens.space1,
                          );
                        },
                        itemCount: provider.contactResponse.data.contactResponse
                            .contactResponseData.contactEdges.length,
                        itemBuilder: (context, index) {
                          animationController.forward();
                          return UserListView(
                            animationController: animationController,
                            animation:
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animationController,
                                curve: Interval(
                                    (1 /6) *
                                        index,
                                    1.0,
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
                            onTap: () async {

                            },
                          );
                        }),
                  ),
                  onRefresh: () {
                    return contactsProvider.doAllContactApiCall();
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
            })));
  }
}
