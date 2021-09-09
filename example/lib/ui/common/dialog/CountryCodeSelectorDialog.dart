import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/country/CountryListProvider.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryCodeSelectorDialog extends StatefulWidget {
  const CountryCodeSelectorDialog(
      {Key key,
      this.countryCodeList,
      this.selectedCountryCode,
      this.onSelectCountryCode})
      : super(key: key);
  final List<CountryCode> countryCodeList;
  final Function(CountryCode) onSelectCountryCode;
  final CountryCode selectedCountryCode;

  @override
  _CountryCodeSelectorDialogState createState() =>
      _CountryCodeSelectorDialogState();
}

class _CountryCodeSelectorDialogState extends State<CountryCodeSelectorDialog>
    with SingleTickerProviderStateMixin {
  CountryRepository countryRepository;
  CountryListProvider countryListProvider;

  ValueHolder valueHolder;
  AnimationController animationController;

  final TextEditingController controllerSearchCountry = TextEditingController();
  List<CountryCode> _searchResult = [];
  final ScrollController scrollController = ScrollController();

  int start = 0, end = 20;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);

    widget.countryCodeList.forEach((element)
    {
      element.flagUri.replaceRange(0, 15, "assets/flags/");
    });

    _searchResult.addAll(widget.countryCodeList);

    controllerSearchCountry.addListener(() {
      if (controllerSearchCountry.text.isEmpty) {
        _searchResult.clear();
        _searchResult.addAll(widget.countryCodeList.getRange(start, end));
        setState(() {});
      } else {
        _searchResult.clear();
        _searchResult.addAll(widget.countryCodeList.where(
          (country) => (country.name
                  .toLowerCase()
                  .contains(controllerSearchCountry.text.toLowerCase()) ||
              country.code
                  .toLowerCase()
                  .contains(controllerSearchCountry.text.toLowerCase()) ||
              country.dialCode
                  .toLowerCase()
                  .contains(controllerSearchCountry.text.toLowerCase())),
        ).toList());
        setState(() {});
      }
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        setState(() {
          start = end;
          end += 10;
          _searchResult.addAll(widget.countryCodeList.getRange(start, end));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    countryRepository = Provider.of<CountryRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);

    return ChangeNotifierProvider<CountryListProvider>(
      lazy: false,
      create: (BuildContext context) {
        this.countryListProvider =
            CountryListProvider(countryListRepository: countryRepository);
        return countryListProvider;
      },
      child: Consumer<CountryListProvider>(builder:
          (BuildContext context, CountryListProvider provider, Widget child) {
        if (widget.countryCodeList != null &&
            widget.countryCodeList.isNotEmpty) {
          return Container(
            height: MediaQuery.of(context).size.height.h,
            width: MediaQuery.of(context).size.width.w,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: Dimens.space70.h,
                  margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                      Dimens.space20.h, Dimens.space10.w, Dimens.space10.h),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: controllerSearchCountry,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.manropeRegular,
                        ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: Dimens.space0.w,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.space10.r)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: Dimens.space0.w,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.space10.r)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: Dimens.space0.w,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.space10.r)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: Dimens.space0.w,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.space10.r)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: Dimens.space0.w,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.space10.r)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: Dimens.space0.w,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.space10.r)),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        CustomIcon.icon_search,
                        color: CustomColors.textPrimaryLightColor,
                        size: Dimens.space16.w,
                      ),
                      fillColor: CustomColors.baseLightColor,
                      hintText: Utils.getString('search'),
                      hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textPrimaryLightColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: Dimens.space16.sp,
                            fontFamily: Config.manropeRegular,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemExtent: Dimens.space52,
                    itemCount: _searchResult.length,
                    itemBuilder: (context, position) {
                      return Container(
                        height: Dimens.space52,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: CustomColors.mainDividerColor,
                                width: Dimens.space1.h),
                          ),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: widget.selectedCountryCode.code ==
                                    _searchResult[position].code
                                ? CustomColors.baseLightColor
                                : CustomColors.transparent,
                          ),
                          onPressed: () {
                            widget.onSelectCountryCode(_searchResult[position]);
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space10.w,
                                    Dimens.space0.h),
                                alignment: Alignment.center,
                                child:
                                // RoundedNetworkSvgHolder(
                                //   containerWidth: Dimens.space24,
                                //   containerHeight: Dimens.space24,
                                //   boxFit: BoxFit.contain,
                                //   imageWidth: Dimens.space24,
                                //   imageHeight: Dimens.space24,
                                //   imageUrl: Config.countryLogoUrl +
                                //       _searchResult[position].flagUri,
                                //   outerCorner: Dimens.space0,
                                //   innerCorner: Dimens.space0,
                                //   iconUrl: CustomIcon.icon_person,
                                //   iconColor: CustomColors.mainColor,
                                //   iconSize: Dimens.space20,
                                //   boxDecorationColor: CustomColors.transparent,
                                // ),
                                RoundedAssetSvgHolder(
                                  containerWidth: Dimens.space24,
                                  containerHeight: Dimens.space24,
                                  boxFit: BoxFit.contain,
                                  imageWidth: Dimens.space24,
                                  imageHeight: Dimens.space24,
                                  assetUrl: 'assets' +
                                      _searchResult[position].flagUri.substring(8, _searchResult[position].flagUri.length),
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  iconUrl: CustomIcon.icon_person,
                                  iconColor: CustomColors.mainColor,
                                  iconSize: Dimens.space20,
                                  boxDecorationColor: CustomColors.transparent,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _searchResult[position].dialCode +
                                        " (" +
                                        _searchResult[position].name +
                                        ") ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(fontWeight: FontWeight.normal)
                                        .copyWith(
                                            color: widget.selectedCountryCode
                                                        .id ==
                                                    _searchResult[position].id
                                                ? CustomColors.textPrimaryColor
                                                : CustomColors
                                                    .textPrimaryLightColor),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height - 100.h,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: SpinKitCircle(
              color: CustomColors.mainColor,
            ),
          );
        }
      }),
    );
  }
}
