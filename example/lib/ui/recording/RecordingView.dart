import 'package:audio_wave/audio_wave.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/recording/RecordingProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/repository/RecordingRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/indicator/CustomLinearProgressIndicator.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/recording/callRecords.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

class RecordingView extends StatefulWidget {
  const RecordingView(
      {Key key,
      @required this.clientId,
      @required this.clientPhoneNumber,
      @required this.clientName,
      @required this.clientProfilePicture})
      : super(key: key);

  final String clientId;
  final String clientPhoneNumber;
  final String clientName;
  final String clientProfilePicture;

  @override
  State<StatefulWidget> createState() {
    return _RecordingViewState();
  }
}

///Toolbar
Widget _appBar(BuildContext context, String title) {
  return AppBar(
    elevation: 1,
    automaticallyImplyLeading: false,
    backgroundColor: CustomColors.white,
    centerTitle: true,
    brightness: Utils.getBrightnessForAppBar(context),
    iconTheme: IconThemeData(color: CustomColors.mainIconColor),
    titleSpacing: 16,
    title: Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Wrap(
              children: [
                Icon(
                  CustomIcon.icon_arrow_left,
                  color: CustomColors.loadingCircleColor,
                  size: Dimens.space22.w,
                ),
                Text(
                  Utils.getString('cancel'),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: CustomColors.loadingCircleColor,
                        fontFamily: Config.manropeBold,
                        fontSize: Dimens.space15.sp,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Text(
              title,
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
        ),
        Expanded(child: Text(""))
      ],
    ),
  );
}

class _RecordingViewState extends State<RecordingView> {
  RecordingProvider recordingProvider;
  RecordingRepository recordingRepository;
  VoidCallback finish;
  final ScrollController _scrollController = ScrollController();
  Status statusLoading = Status.SUCCESS;

  @override
  void initState() {
    super.initState();
    recordingRepository =
        Provider.of<RecordingRepository>(context, listen: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (pageInfo.hasNextPage) {
          setState(() {
            statusLoading = Status.PROGRESS_LOADING;
          });
          recordingProvider
              .doNextRecordingApiCall(widget.clientPhoneNumber)
              .whenComplete(() {
            if (recordingProvider.listRecordingConversationDetails.status ==
                Status.SUCCESS) {
              setState(() {
                setState(() {
                  statusLoading = Status.SUCCESS;
                });
                listRecordingConversationDetails =
                    recordingProvider.listRecordingConversationDetails.data;
                pageInfo =
                    recordingProvider.recordingConversationPagination.data;
              });
            }
          });
        }
      }
    });
  }

  List<Content> listRecordingConversationDetails = [];
  PageInfo pageInfo;
  Content listConversationEdge;

  @override
  void dispose() {
    listConversationEdge.advancedPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<RecordingProvider>(
            lazy: false,
            create: (BuildContext context) {
              recordingProvider =
                  RecordingProvider(recordingRepository: recordingRepository);
              recordingProvider
                  .doRecordingApiCall(widget.clientPhoneNumber)
                  .whenComplete(() {
                if (recordingProvider.listRecordingConversationDetails.status ==
                    Status.SUCCESS) {
                  setState(() {
                    listRecordingConversationDetails =
                        recordingProvider.listRecordingConversationDetails.data;
                    pageInfo =
                        recordingProvider.recordingConversationPagination.data;
                  });
                }
              });
              return recordingProvider;
            }),
      ],
      child: Consumer<RecordingProvider>(
        builder:
            (BuildContext context, RecordingProvider provider, Widget child) {
          return Scaffold(
              backgroundColor: CustomColors.mainBackgroundColor,
              appBar: _appBar(context, Utils.getString("recordings")),
              body: LayoutBuilder(builder: (context, constraints) {
                if (provider.listRecordingConversationDetails.data == null) {
                  return SpinKitCircle(
                    color: CustomColors.mainColor,
                  );
                } else {
                  return RefreshIndicator(
                      color: CustomColors.mainColor,
                      backgroundColor: CustomColors.white,
                      child: Stack(
                        children: [
                          _listOfCallRecords(
                              provider.listRecordingConversationDetails.data,
                              context),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: CustomLinearProgressIndicator(statusLoading),
                          ),
                        ],
                      ),
                      onRefresh: () {
                        return recordingProvider
                            .doRecordingApiCall(widget.clientPhoneNumber);
                      });
                }
              }));
        },
      ),
    );
  }

  ///Return widget of list and return if data is null
  @swidget
  Widget _listOfCallRecords(
      List<Content> listConversationEdge, BuildContext context) {
    if (listRecordingConversationDetails.length > 0) {
      return ListView.builder(
        controller: _scrollController,
        itemCount: listRecordingConversationDetails == null
            ? 0
            : listRecordingConversationDetails.length,
        itemBuilder: (context, i) {
          return _itemRecording(listRecordingConversationDetails[i],
              height: 70.h, position: i);
        },
      );
    } else {
      return _noRecording();
    }
  }

  ///Items view of list of recording
  @swidget
  Widget _itemRecording(Content listConversationEdge,
      {double height = 50.0, @required int position}) {
    var seekTotal = "0";
    listConversationEdge.advancedPlayer.setUrl(listConversationEdge.body);
    listConversationEdge.advancedPlayer.onDurationChanged.listen((event) {
      seekTotal = event.inSeconds.toString();
      setState(() {
        listRecordingConversationDetails[position].duration = seekTotal;
      });
    });

    var bgColorPlayBlue = CustomColors.progressBarColor;
    var bgColorInactivePlayBlue = CustomColors.progressBarInactiveColor;

    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w, bottom: 10.h),
      child: Stack(
        children: [
          ///background
          Visibility(
            visible: listConversationEdge.advancePlayDefault ? false : true,
            child: Container(
              margin: EdgeInsets.only(top: 0.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.space10),
                ),
              ),
              height: height,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: height,
                    width: 168.w,
                    decoration: BoxDecoration(
                      color: bgColorPlayBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.space10),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: height,
                    width: 168.w,
                    decoration: BoxDecoration(
                      color: !listConversationEdge.isPlaySeekFinish
                          ? Colors.transparent
                          : bgColorPlayBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.space10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///slider
          Visibility(
            visible: listConversationEdge.advancePlayDefault ? false : true,
            child: Container(
              margin: EdgeInsets.only(left: 40.h, right: 40.h),
              child: SliderTheme(
                data: SliderThemeData(
                    trackHeight: height,
                    thumbColor: Colors.transparent,
                    activeTrackColor: bgColorPlayBlue,
                    inactiveTrackColor: bgColorInactivePlayBlue,
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 0, disabledThumbRadius: 0)),
                child: Slider(
                  min: 0.0,
                  max: double.parse(listConversationEdge.duration),
                  value: double.parse(listConversationEdge.seekData),
                  onChanged: (val) {
                    Duration newDuration = Duration(seconds: val.toInt());
                    listRecordingConversationDetails[position]
                        .advancedPlayer
                        .seek(newDuration);
                    setState(() {
                      if (double.parse(listConversationEdge.seekData) >=
                          double.parse(listConversationEdge.duration)) {
                        listRecordingConversationDetails[position]
                            .isPlaySeekFinish = true;
                      } else {
                        listRecordingConversationDetails[position]
                            .isPlaySeekFinish = false;
                      }
                    });
                  },
                ),
              ),
            ),
          ),

          ///content
          Container(
            margin: EdgeInsets.fromLTRB(
                Dimens.space16.w,
                !listConversationEdge.isPlay
                    ? Dimens.space15.h
                    : Dimens.space0.h,
                Dimens.space26.w,
                Dimens.space0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                RoundedNetworkImageHolder(
                  width: Dimens.space40,
                  height: Dimens.space40,
                  boxFit: BoxFit.cover,
                  iconUrl: listConversationEdge.isPlay
                      ? CustomIcon.icon_pause
                      : CustomIcon.icon_play,
                  iconColor: CustomColors.white,
                  iconSize: Dimens.space14,
                  outerCorner: Dimens.space14,
                  innerCorner: Dimens.space0,
                  boxDecorationColor: (listConversationEdge.advancePlayDefault)
                      ? CustomColors.textQuaternaryColor
                      : CustomColors.loadingCircleColor,
                  imageUrl: "",
                  onTap: () async {
                    setState(() {
                      this.listConversationEdge = listConversationEdge;
                    });

                    _changeToDefaultView(position);
                    var voiceUrl = "";
                    if (listConversationEdge.body != null) {
                      voiceUrl = listConversationEdge.body;
                    } else {
                      voiceUrl = listConversationEdge.transferedAudio;
                    }

                    bool isPlay;
                    if (listRecordingConversationDetails[position].isPlay) {
                      await listConversationEdge.advancedPlayer.pause();
                      isPlay = false;
                    } else {
                      await listConversationEdge.advancedPlayer.play(voiceUrl);
                      isPlay = true;
                    }

                    ///Seek
                    listConversationEdge.advancedPlayer.onAudioPositionChanged
                        .listen((event) {
                      setState(() {
                        listRecordingConversationDetails[position].seekData =
                            event.inSeconds.toString();
                      });
                    });

                    ///Complete on audio play
                    listConversationEdge.advancedPlayer.onPlayerCompletion
                        .listen((event) {
                      setState(() {
                        listRecordingConversationDetails[position].isPlay =
                            false;
                        listRecordingConversationDetails[position]
                            .isPlaySeekFinish = false;
                        listRecordingConversationDetails[position].seekData =
                            "0";
                      });
                    });
                    setState(() {
                      listRecordingConversationDetails[position].isPlay =
                          isPlay;
                    });
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 32.w, right: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///Time
                      Visibility(
                        visible: listConversationEdge.isPlay ? false : true,
                        child: Text(
                          "Call Recording $position",
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: listConversationEdge.advancePlayDefault
                                  ? CustomColors.textPrimaryColor
                                  : CustomColors.loadingCircleColor,
                              fontFamily: "Manrope",
                              fontSize: Dimens.space16.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),

                      ///Time
                      Visibility(
                        visible: listConversationEdge.isPlay ? false : true,
                        child: Text(
                          _dateConversion(listConversationEdge.time),
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: listConversationEdge.advancePlayDefault
                                  ? CustomColors.textPrimaryColor
                                  : CustomColors.loadingCircleColor,
                              fontFamily: "Manrope",
                              fontSize: Dimens.space13.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),

                      ///audio wave
                      Visibility(
                        visible: listConversationEdge.isPlay ? true : false,
                        child: AudioWave(
                          height: 70.h,
                          width: (MediaQuery.of(context).size.width - 196).w,
                          spacing: 5,
                          beatRate: Duration(milliseconds: 50),
                          animationLoop: 1,
                          bars: [
                            AudioWaveBar(height: 5, color: Colors.blue),
                            AudioWaveBar(height: 10, color: Colors.blue),
                            AudioWaveBar(height: 15, color: Colors.blue),
                            AudioWaveBar(height: 25, color: Colors.blue),
                            AudioWaveBar(height: 20, color: Colors.blue),
                            AudioWaveBar(height: 25, color: Colors.blue),
                            AudioWaveBar(height: 15, color: Colors.blue),
                            AudioWaveBar(height: 15, color: Colors.blue),
                            AudioWaveBar(height: 10, color: Colors.blue),
                            AudioWaveBar(height: 5, color: Colors.blue),
                            // AudioWaveBar(height: 5, color: Colors.blue),
                            // AudioWaveBar(height: 25, color: Colors.blue),
                            AudioWaveBar(height: 15, color: Colors.blue),
                            // AudioWaveBar(height: 25, color: Colors.blue),
                            // AudioWaveBar(height: 15, color: Colors.blue),
                            // AudioWaveBar(height: 25, color: Colors.blue),
                            // AudioWaveBar(height: 15, color: Colors.blue),
                            AudioWaveBar(height: 10, color: Colors.blue),
                            AudioWaveBar(height: 5, color: Colors.blue),
                            AudioWaveBar(height: 15, color: Colors.blue),
                            AudioWaveBar(height: 25, color: Colors.blue),
                            AudioWaveBar(height: 25, color: Colors.blue),
                            AudioWaveBar(height: 10, color: Colors.blue),
                            AudioWaveBar(height: 25, color: Colors.blue),
                            AudioWaveBar(height: 15, color: Colors.blue),
                            AudioWaveBar(height: 10, color: Colors.blue),
                            AudioWaveBar(height: 5, color: Colors.blue),
                            AudioWaveBar(height: 10, color: Colors.blue),
                            AudioWaveBar(height: 15, color: Colors.blue),
                            AudioWaveBar(height: 25, color: Colors.blue),
                            AudioWaveBar(height: 25, color: Colors.blue),
                            AudioWaveBar(height: 15, color: Colors.blue),
                            AudioWaveBar(height: 10, color: Colors.blue),
                            AudioWaveBar(height: 5, color: Colors.blue),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  _printDuration(Duration(
                      seconds: int.parse(listConversationEdge.duration))),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: listConversationEdge.advancePlayDefault
                          ? CustomColors.textPrimaryColor
                          : CustomColors.loadingCircleColor,
                      fontFamily: "Manrope",
                      fontSize: Dimens.space13.sp,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Making sure other view don't are to default and don't overlay audio
  _changeToDefaultView(int position) {
    listRecordingConversationDetails[position].advancePlayDefault = false;
    for (int i = 0; i < listRecordingConversationDetails.length; i++) {
      if (position != i) {
        listRecordingConversationDetails[i].isPlay = false;
        listRecordingConversationDetails[i].isPlaySeekFinish = false;
        listRecordingConversationDetails[i].advancePlayDefault = true;
        listRecordingConversationDetails[i].advancedPlayer.stop();
      }
    }
  }

  ///Date Time format
  String _dateConversion(String time) {
    try {
      if (time != "" || time != null) {
        String data = time;
        final dateTime = DateTime.parse(data).toLocal();

        final format = DateFormat('MMM dd, yyyy - hh:mm a');
        final dataTime = format.format(dateTime);
        return dataTime;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  ///Return widget if no Recording found
  @swidget
  Widget _noRecording() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/no_recording.svg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            allowDrawingOutsideViewBox: false,
          ),
          Text(
            Utils.getString('noCallRecording'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: CustomColors.textPrimaryColor,
                  fontFamily: Config.manropeRegular,
                  fontSize: Dimens.space20.sp,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
          ),
          Text(
            Utils.getString('noCallRecordingData'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: CustomColors.textTertiaryColor,
                  fontFamily: Config.manropeRegular,
                  fontSize: Dimens.space15.sp,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ],
      ),
    );
  }

  ///Voice Mail Duration Trim
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
