import 'package:quiver/core.dart';
import 'package:voice_example/viewobject/common/Object.dart';

class NotificationMessage extends Object<NotificationMessage>
{
  NotificationMessage({
    this.data,
  });

  Data data;

  @override
  bool operator ==(dynamic other) => other is NotificationMessage && data.id == other.data.id;

  @override
  int get hashCode => hash2(data.id.hashCode, data.id.hashCode);

  @override
  String getPrimaryKey()
  {
    return "";
  }




  NotificationMessage.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  @override
  NotificationMessage fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return NotificationMessage(
          data: Data().fromMap(dynamicData['data']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(NotificationMessage object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['data'] = Data().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<NotificationMessage> fromMapList(List<dynamic> dynamicDataList) {
    final List<NotificationMessage> subCategoryList = <NotificationMessage>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<NotificationMessage> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (NotificationMessage data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}

class Notification extends Object<Notification>{
  String body;
  String title;

  Notification({this.body, this.title});

  Notification.fromJson(Map<String, dynamic> json)
  {
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    return data;
  }

  @override
  Notification fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return Notification(
        body: dynamicData['body'],
        title: dynamicData['title'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  List<Notification> fromMapList(List<dynamic> dynamicDataList) {
    final List<Notification> subCategoryList = <Notification>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Notification> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Notification data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  Map<String, dynamic> toMap(Notification object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['body'] = object.body;
      data['title'] = object.title;
      return data;
    } else {
      return null;
    }
  }
}

class Data extends Object<Data>
{
  int id;
  String twiCallSid;
  String twiTo;
  String twiFrom;
  CustomParameters customParameters;
  ChannelInfo channelInfo;

  Data({
    this.id,
    this.twiCallSid,
    this.twiTo,
    this.twiFrom,
    this.customParameters,
    this.channelInfo
  });

  Data.fromJson(Map<String, dynamic> json)
  {
    id=1;
    twiCallSid = json['twi_call_sid'];
    twiTo = json['twi_to'];
    twiFrom = json['twi_from'];
    customParameters = json['customParameters'] != null
        ?  CustomParameters.fromJson(json['customParameters'])
        : null;
    channelInfo = json['channelInfo'] != null
        ?  ChannelInfo.fromJson(json['channelInfo'])
        : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['twi_call_sid'] = this.twiCallSid;
    data['twi_to'] = this.twiTo;
    data['twi_from'] = this.twiFrom;
    if (this.customParameters != null) {
      data['customParameters'] = this.customParameters.toJson();
    }
    if (this.channelInfo != null) {
      data['channelInfo'] = this.channelInfo.toJson();
    }
    return data;
  }

  @override
  Data fromMap(dynamic dynamicData) {
    if (dynamicData != null)
    {
      return Data(
        id: 1,
        twiCallSid: dynamicData['twi_call_sid'],
        twiTo: dynamicData['twi_to'],
        twiFrom: dynamicData['twi_from'],
        customParameters: CustomParameters().fromMap(dynamicData['customParameters']),
        channelInfo: ChannelInfo().fromMap(dynamicData['channelInfo']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Data object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id']=1;
      data['twi_call_sid'] = object.twiCallSid;
      data['twi_to'] =object.twiTo;
      data['twi_from'] = object.twiFrom;
      data['customParameters'] = CustomParameters().toMap(object.customParameters);
      data['channelInfo'] = ChannelInfo().toMap(object.channelInfo);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Data> fromMapList(List<dynamic> dynamicDataList) {
    final List<Data> subCategoryList = <Data>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Data> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Data data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }
}

class CustomParameters extends Object<CustomParameters>
{
  String conversationId;
  String afterHold;
  String contactNumber;
  String contactName;
  String channelSid;

  CustomParameters({
    this.conversationId,
    this.afterHold,
    this.contactNumber,
    this.contactName,
    this.channelSid,
  });

  CustomParameters.fromJson(Map<String, dynamic> json)
  {
    conversationId = json['conversation_id'];
    afterHold = json['after_hold'];
    contactNumber = json['contact_number'];
    contactName = json['contact_name'];
    channelSid = json['channel_sid'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['conversation_id'] = this.conversationId;
    data['after_hold'] = this.afterHold;
    data['contact_number'] = this.contactNumber;
    data['contact_name'] = this.contactName;
    data['channel_sid'] = this.channelSid;
    return data;
  }

  @override
  CustomParameters fromMap(dynamic dynamicData) {
    if (dynamicData != null) 
    {
      return CustomParameters(
        conversationId: dynamicData['conversation_id'],
        afterHold: dynamicData['after_hold'],
        contactNumber: dynamicData['contact_number'],
        contactName: dynamicData['contact_name'],
        channelSid: dynamicData['channel_sid'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(CustomParameters object) {
    if (object != null) 
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['conversation_id'] = object.conversationId;
      data['after_hold'] =object.afterHold;
      data['contact_number'] = object.contactNumber;
      data['contact_name'] = object.contactName;
      data['channel_sid'] = object.channelSid;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CustomParameters> fromMapList(List<dynamic> dynamicDataList) {
    final List<CustomParameters> subCategoryList = <CustomParameters>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<CustomParameters> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (CustomParameters data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }
}

class ChannelInfo extends Object<ChannelInfo>
{
  String number;
  String country;
  String countryCode;
  String name;
  String id;
  String numberSid;
  String countryLogo;

  ChannelInfo({
    this.number,
    this.country,
    this.countryCode,
    this.name,
    this.id,
    this.numberSid,
    this.countryLogo,
  });

  ChannelInfo.fromJson(Map<String, dynamic> json)
  {
    number = json['number'];
    country = json['country'];
    countryCode = json['country_code'];
    name = json['name'];
    id = json['id'];
    numberSid = json['number_sid'];
    countryLogo = json['country_logo'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['number'] = this.number;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    data['name'] = this.name;
    data['id'] = this.id;
    data['number_sid'] = this.numberSid;
    data['country_logo'] = this.countryLogo;
    return data;
  }

  @override
  ChannelInfo fromMap(dynamic dynamicData) {
    if (dynamicData != null)
    {
      return ChannelInfo(
        number: dynamicData['number'],
        country: dynamicData['country'],
        countryCode: dynamicData['country_code'],
        name: dynamicData['name'],
        id: dynamicData['id'],
        numberSid: dynamicData['number_sid'],
        countryLogo: dynamicData['country_logo'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ChannelInfo object) {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['number'] = object.number;
      data['country'] =object.country;
      data['country_code'] = object.countryCode;
      data['name'] = object.name;
      data['id'] = object.id;
      data['number_sid'] =object.numberSid;
      data['country_logo'] = object.countryLogo;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChannelInfo> fromMapList(List<dynamic> dynamicDataList) {
    final List<ChannelInfo> subCategoryList = <ChannelInfo>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ChannelInfo> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ChannelInfo data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }
}