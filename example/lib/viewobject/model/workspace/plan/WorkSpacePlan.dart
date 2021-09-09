import 'package:flutter/material.dart';
import 'package:voice_example/viewobject/common/Object.dart';

class PlanOverviewData extends Object<PlanOverviewData>
{

  PlanOverviewData({
    this.cardInfo,
    this.remainingDays,
    this.subscriptionActive,
    this.trialPeriod
  });

  bool cardInfo;
  int remainingDays;
  String subscriptionActive;
  String trialPeriod;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  PlanOverviewData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return PlanOverviewData(
        cardInfo: dynamicData['cardInfo'],
        remainingDays: dynamicData['remainingDays'],
        subscriptionActive: dynamicData['subscriptionActive'],
        trialPeriod: dynamicData['trialPeriod'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(PlanOverviewData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['cardInfo'] = object.cardInfo;
      data['remainingDays'] = object.remainingDays;
      data['subscriptionActive'] = object.subscriptionActive;
      data['trialPeriod'] = object.trialPeriod;

      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<PlanOverviewData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<PlanOverviewData> userData = <PlanOverviewData>[];
    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          userData.add(fromMap(dynamicData));
        }
      }
    }
    return userData;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<PlanOverviewData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (PlanOverviewData data in objectList)
      {
        if (data != null)
        {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}