
import 'package:voice_example/viewobject/model/login/Login.dart';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/ResponseData.dart';

class User extends Object<User>
{
  User({
    this.login,
  });

  Login login;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  User fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return User(login: Login().fromMap(dynamicData['login']),);
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(User object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['login'] = Login().toMap(object.login);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<User> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<User> userData = <User>[];
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
  List<Map<String, dynamic>> toMapList(List<User> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (User data in objectList)
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

class ChangeProfileName extends Object<ChangeProfileName>
{
  ChangeProfileName({
    this.profile,
  });

  String token;
  ResponseData profile;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ChangeProfileName fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ChangeProfileName(
        profile: ResponseData().fromMap(dynamicData['changeProfileNames']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ChangeProfileName object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['changeProfileNames'] = ResponseData().toMap(object.profile);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChangeProfileName> fromMapList(List<dynamic> dynamicDataList) {
    final List<ChangeProfileName> data = <ChangeProfileName>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData));
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ChangeProfileName> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ChangeProfileName data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}

class UpdateUserEmail extends Object<UpdateUserEmail>
{
  UpdateUserEmail({
    this.data,
  });

  ResponseData data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  UpdateUserEmail fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UpdateUserEmail(
        data: ResponseData().fromMap(dynamicData['changeEmail']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(UpdateUserEmail object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['changeEmail'] = ResponseData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UpdateUserEmail> fromMapList(List<dynamic> dynamicDataList) {
    final List<UpdateUserEmail> data = <UpdateUserEmail>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData));
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<UpdateUserEmail> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (UpdateUserEmail data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}

class UpdateUserProfilePicture extends Object<UpdateUserProfilePicture>
{
  UpdateUserProfilePicture({
    this.data,
  });

  ResponseData data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  UpdateUserProfilePicture fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UpdateUserProfilePicture(
        data: ResponseData().fromMap(dynamicData['changeProfilePicture']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(UpdateUserProfilePicture object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['changeProfilePicture'] = ResponseData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UpdateUserProfilePicture> fromMapList(List<dynamic> dynamicDataList) {
    final List<UpdateUserProfilePicture> data = <UpdateUserProfilePicture>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData));
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>> toMapList(
      List<UpdateUserProfilePicture> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (UpdateUserProfilePicture data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}

class ChangePassword extends Object<ChangePassword>
{
  ChangePassword({
    this.data,
  });

  ResponseData data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ChangePassword fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ChangePassword(
        data: ResponseData().fromMap(dynamicData['changePassword']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ChangePassword object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['changePassword'] = ResponseData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChangePassword> fromMapList(List<dynamic> dynamicDataList) {
    final List<ChangePassword> data = <ChangePassword>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData));
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ChangePassword> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ChangePassword data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
