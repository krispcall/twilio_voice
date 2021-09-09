import 'dart:io';
import 'package:graphql/client.dart';
import 'package:voice_example/api/common/Api.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/query/QueryMutation.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/Empty.dart';
import 'package:voice_example/viewobject/ResponseData.dart';
import 'package:voice_example/viewobject/holder/request_holder/addContactRequestParamHolder/AddContactRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNoteByNumberRequestParamHolder/AddNoteByNumberRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addTagRequestParamHolder/AddTagRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addTagsToContactRequestParamHolder/AddTagsToContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/allContactRequestParamHolder/AllContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/blockContactResponse/BlockContactResponse.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactDetailRequestParamHolder/ContactDetailRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/SearchConversationRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/editContactRequestHolder/EditContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/pageRequestParamHolder/PageRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/recentConversationRequestParamHolder/RecentConversationRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/CommonRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/sendMessageRequestParamHolder/SendMessageRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart';
import 'package:voice_example/viewobject/model/addContact/AddContactResponse.dart';
import 'package:voice_example/viewobject/model/addNoteByNumber/AddNoteByNumberResponse.dart';
import 'package:voice_example/viewobject/model/addNotes/AddNoteResponse.dart';
import 'package:voice_example/viewobject/model/addTag/AddTagResponse.dart';
import 'package:voice_example/viewobject/model/allNotes/AllNotesResponse.dart';
import 'package:voice_example/viewobject/model/allTags/AllTagsResponse.dart';
import 'package:voice_example/viewobject/model/allTags/EditTagResponse.dart';
import 'package:voice_example/viewobject/model/appInfo/AppInfo.dart';
import 'package:voice_example/viewobject/model/call/NewCountResponse.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationResponse.dart';
import 'package:voice_example/viewobject/model/allContact/Contact.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactResponse.dart';
import 'package:voice_example/viewobject/model/channel/ChannelResponse.dart';
import 'package:voice_example/viewobject/model/checkDuplicateLogin/CheckDuplicateLogin.dart';
import 'package:voice_example/viewobject/model/clientDndResponse/ClientDndResponse.dart';
import 'package:voice_example/viewobject/model/contactDetail/ContactDetailResponse.dart';
import 'package:voice_example/viewobject/model/conversation_detail/ConversationDetailResponse.dart';
import 'package:voice_example/viewobject/model/country/CountryList.dart';
import 'package:voice_example/viewobject/model/deviceInfo/DeviceInfoResponse.dart';
import 'package:voice_example/viewobject/model/editContact/EditContactResponse.dart';
import 'package:voice_example/viewobject/model/invite/InviteMemberResponse.dart';
import 'package:voice_example/viewobject/model/login/User.dart';
import 'package:voice_example/viewobject/model/memberLogin/Member.dart';
import 'package:voice_example/viewobject/model/members/MembersResponse.dart';
import 'package:voice_example/viewobject/model/members/SubscriptionOnlineMemberStatus.dart';
import 'package:voice_example/viewobject/model/numbers/NumberResponse.dart';
import 'package:voice_example/viewobject/model/onlineStatus/onlineStatusResponse.dart';
import 'package:voice_example/viewobject/model/overview/OverViewResponse.dart';
import 'package:voice_example/viewobject/model/pinContact/PinContactResponse.dart';
import 'package:voice_example/viewobject/model/profile/Profile.dart';
import 'package:voice_example/viewobject/model/recording/callRecord.dart';
import 'package:voice_example/viewobject/model/refreshToken/RefreshTokenResponse.dart';
import 'package:voice_example/viewobject/model/sendMessage/SendMessageResponse.dart';
import 'package:voice_example/viewobject/model/subscriptionConversationDetail/SubscriptionConversationDetailResponse.dart';
import 'package:voice_example/viewobject/model/teams/TeamsResponse.dart';
import 'package:voice_example/viewobject/model/teams/addTeams/AddTeamResponse.dart';
import 'package:voice_example/viewobject/model/voiceToken/VoiceTokenResponse.dart';
import 'package:voice_example/viewobject/model/workspace/addWorkspace/AddWorkSpaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/archive/ArchiveWorkSpaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/restore/RestoreWorkspaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/uploadImage/UploadWorkSpaceImageResponse.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/Workspace.dart';
import 'package:voice_example/viewobject/model/workspace/workspacelist/WorkspaceListResponse.dart';
import 'package:voice_example/viewobject/model/workspace_switch/WorkspaceSwitch.dart';

import 'common/Api.dart';
import 'common/Resources.dart';

class ApiService extends Api {
  ///
  Future<Resources<AppInfo>> doVersionApiCall() async {
    return await doServerCallQueryWithoutAuth<AppInfo, AppInfo>(
        AppInfo(), QueryMutation().queryAppInfo());
  }

  ///
  /// User Login
  ///
  Future<Resources<User>> doUserLoginApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallMutationWithoutAuth<User, User>(
        User(),
        CommonRequestHolder(data: jsonMap).toMap(),
        QueryMutation().mutationLogin());
  }

  ///
  /// User CheckDuplicateLogin
  ///
  Future<Resources<CheckDuplicateLogin>> doCheckDuplicateLogin(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallMutationWithoutAuth<CheckDuplicateLogin,
        CheckDuplicateLogin>(
      CheckDuplicateLogin(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().checkDuplicateLogin(),
    );
  }

  ///
  /// User Call Access and Refresh Token
  ///
  Future<Resources<Member>> doWorkSpaceLoginApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallMutationWithApiAuth<Member, Member>(
      Member(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationMemberLogin(),
    );
  }

  ///
  /// User Voice Token
  ///
  Future<Resources<VoiceTokenResponse>> doVoiceTokenApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallMutationWithAuth<VoiceTokenResponse,
        VoiceTokenResponse>(
      VoiceTokenResponse(),
      jsonMap,
      QueryMutation().queryVoiceToken(),
    );
  }

  ///
  /// User Login
  ///
  Future<Resources<DeviceInfoResponse>> doDeviceRegisterApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallMutationWithApiAuth<DeviceInfoResponse,
            DeviceInfoResponse>(
        DeviceInfoResponse(),
        CommonRequestHolder(data: jsonMap).toMap(),
        QueryMutation().mutationCreateDeviceInfo());
  }

  ///
  /// User WorkSpace Detail
  ///
  Future<Resources<Workspace>> doLoginWorkSpaceDetailApiCall() async {
    return await doServerCallQueryWithCallAccessToken<Workspace, Workspace>(
        Workspace(), QueryMutation().mutationWorkspaceDetail());
  }

  ///
  /// User WorkSpace Change
  ///
  Future<Resources<WorkspaceSwitch>> doChangeWorkspaceApiCall(
      Map<String, dynamic> jsonMap) async {
    return await doServerCallMutationWithApiAuth<WorkspaceSwitch,
        WorkspaceSwitch>(
      WorkspaceSwitch(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationWorkspaceSwitch(),
    );
  }

  ///
  /// User Profile Details for Profile APi
  ///
  Future<Resources<dynamic>> getUserProfileDetails() async {
    return await doServerCallQueryWithAuth<Profile, Profile>(
      Profile(),
      QueryMutation().getUserProfileDetails(),
    );
  }

  ///
  /// User Change Password
  ///
  // Future<Resources<ChangePassword>> postChangePassword(Map<dynamic, dynamic> jsonMap) async
  // {
  //   return await postDataMutation<ChangePassword, ChangePassword>(
  //       ChangePassword(),
  //       CommonRequestHolder(data: jsonMap).toMap(),
  //       QueryMutation().mutationChangePassword(),
  //       PsSharedPreferences.instance.shared
  //           .getString(Const.VALUE_HOLDER_API_TOKEN));
  // }

  ///
  /// User name Update
  ///
  // Future<Resources<ChangeProfileName>> postUserNameUpdate(Map<dynamic, dynamic> jsonMap) async
  // {
  //   return await postDataMutation<ChangeProfileName, ChangeProfileName>(
  //       ChangeProfileName(),
  //       CommonRequestHolder(data: jsonMap).toMap(),
  //       QueryMutation().mutationEditProfileName(),
  //       PsSharedPreferences.instance.shared.getString(Const.VALUE_HOLDER_API_TOKEN));
  // }

  ///
  /// User name Update
  ///
  Future<Resources<UpdateUserEmail>> postUserEmailUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallMutationWithAuth<UpdateUserEmail, UpdateUserEmail>(
      UpdateUserEmail(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationEditUserEmail(),
    );
  }

  ///
  /// User name Update
  ///
  // Future<Resources<UpdateUserProfilePicture>> postUserProfileImageUpdate(String userId, String platformName, File imageFile) async
  // {
  //   Map<String, dynamic> imageBase64Map = Utils.convertImageToBase64String("photo_upload", imageFile);
  //   return await postDataMutation<UpdateUserProfilePicture, UpdateUserProfilePicture>(
  //       UpdateUserProfilePicture(),
  //       imageBase64Map,
  //       QueryMutation().mutationUploadProfileImage(),
  //       PsSharedPreferences.instance.shared
  //           .getString(Const.VALUE_HOLDER_API_TOKEN));
  // }

  Future<Resources<RecentConversationResponse>> doCallLogsApiCall(
      RecentConversationRequestHolder param) async {
    return await doServerCallMutationWithAuth<RecentConversationResponse,
            RecentConversationResponse>(RecentConversationResponse(),
        param.toMap(), QueryMutation().queryCallLogs());
  }

  Future<Resources<PinContactResponse>> doContactPinUnpinApiCall(
      ContactPinUnpinRequestHolder param) async {
    return await doServerCallMutationWithAuth<PinContactResponse,
            PinContactResponse>(
        PinContactResponse(),
        CommonRequestHolder(data: param.toMap()).toMap(),
        QueryMutation().mutationPinConversationContact());
  }

  Future<Resources<NewCountResponse>> getNewCountOfCallLog(
      Map<String, dynamic> param) async {
    return await doServerCallQueryWithAuthQueryAndVariable<NewCountResponse,
        NewCountResponse>(
      NewCountResponse(),
      QueryMutation().queryNewCount(),
      param,
    );
  }

  Future<Resources<Empty>> deleteCallLog(String jsonMap) async {}

  Future<Resources<AllContactResponse>> doAllContactApiCall(
      AllContactRequestHolder jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<AllContactResponse,
        AllContactResponse>(
      AllContactResponse(),
      QueryMutation().getAllContacts(),
      jsonMap.toMap(),
    );
  }

  Future<Resources<ContactDetailResponse>> doContactDetailApiCall(
      ContactDetailRequestParamHolder jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<
        ContactDetailResponse, ContactDetailResponse>(
      ContactDetailResponse(),
      QueryMutation().queryContactDetail(),
      jsonMap.toMap(),
    );
  }

  Future<Resources<AllTagsResponse>> doGetAllTagsApiCall() async {
    return await doServerCallQueryWithCallAccessToken<AllTagsResponse,
        AllTagsResponse>(
      AllTagsResponse(),
      QueryMutation().queryGetAllTags(),
    );
  }

  Future<Resources<AllNotesResponse>> doGetAllNotesApiCall(
      ContactPinUnpinRequestHolder param) async {
    return await doServerCallQueryWithAuthQueryAndVariable<AllNotesResponse,
        AllNotesResponse>(
      AllNotesResponse(),
      QueryMutation().queryClientNotes(),
      param.toMap(),
    );
  }

  Future<Resources<AddTagResponse>> doAddNewTagApiCall(
      AddTagRequestParamHolder jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<AddTagResponse,
        AddTagResponse>(
      AddTagResponse(),
      QueryMutation().addTagsQuery(),
      CommonRequestHolder(data: jsonMap.toMap()).toMap(),
    );
  }

  Future<Resources<EditContactResponse>> doEditContactApiCall(
      AddTagsToContactRequestHolder jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<EditContactResponse,
        EditContactResponse>(
      EditContactResponse(),
      QueryMutation().mutationAddTagsToContact(),
      jsonMap.toMap(),
    );
  }

  Future<Resources<EditContactResponse>> editContactApiCall(
      EditContactRequestHolder jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<EditContactResponse,
        EditContactResponse>(
      EditContactResponse(),
      QueryMutation().mutationAddTagsToContact(),
      jsonMap.toMap(),
    );
  }

  Future<Resources<AddContactResponse>> doAddContactsApiCall(
      AddContactRequestParamHolder jsonMap, File file) async {
    if (file != null) {
      Map<String, dynamic> imageBase64Map =
          Utils.convertImageToBase64String("photoUpload", file);
      jsonMap.toMap().addAll(imageBase64Map);
    }
    return await doServerCallMutationWithAuth<AddContactResponse,
        AddContactResponse>(
      AddContactResponse(),
      CommonRequestHolder(data: jsonMap.toMap()).toMap(),
      QueryMutation().mutationAddNewContacts(),
    );
  }

  Future<Resources<AddContactResponse>> postAddContacts(
      Map<dynamic, dynamic> jsonMap, File file) async {
    if (file != null) {
      Map<String, dynamic> imageBase64Map =
          Utils.convertImageToBase64String("photoUpload", file);
      jsonMap.addAll(imageBase64Map);
    }

    return await doServerCallMutationWithAuth<AddContactResponse,
        AddContactResponse>(
      AddContactResponse(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationAddNewContacts(),
    );
  }

  Future<Resources<EditContactResponse>> putEditContacts(
      Map<dynamic, dynamic> jsonMap, String id) async {
    return await doServerCallMutationWithAuth<EditContactResponse,
        EditContactResponse>(
      EditContactResponse(),
      {"data": Map<String, dynamic>.from(jsonMap), "id": "${id}"},
      QueryMutation().mutationEditContacts(),
    );
  }

  Future<Resources<DeleteContactResponse>> deleteContact(
      List<String> jsonMap) async {
    return await doServerCallMutationWithAuth<DeleteContactResponse,
        DeleteContactResponse>(
      DeleteContactResponse(),
      {
        "data": {"contacts": jsonMap},
      },
      QueryMutation().mutationDeleteContacts(),
    );
  }

  Future<Resources<BlockContactResponse>> blockContact(
      Map<dynamic, dynamic> jsonMap, String id) async {
    return await doServerCallMutationWithAuth<BlockContactResponse,
        BlockContactResponse>(
      BlockContactResponse(),
      {"data": Map<String, dynamic>.from(jsonMap), "uid": "${id}"},
      QueryMutation().blockContact(),
    );
  }

  Future<Resources<CountryList>> getAllCountries(int limit, int offset) async {
    return await doServerCallQueryWithAuth<CountryList, CountryList>(
      CountryList(),
      QueryMutation().getAllCountries(),
    );
  }

  Future<Resources<SendMessageResponse>> doSendMessageApiCall(
      SendMessageRequestHolder jsonMap) async {
    return await doServerCallMutationWithAuth<SendMessageResponse,
            SendMessageResponse>(
        SendMessageResponse(),
        CommonRequestHolder(data: jsonMap.toMap()).toMap(),
        QueryMutation().mutationSendNewMessage());
  }

  Future<Resources<ConversationDetailResponse>>
      doConversationDetailByContactApiCall(
          ConversationDetailRequestHolder param) async {
    return await doServerCallMutationWithAuth<ConversationDetailResponse,
            ConversationDetailResponse>(ConversationDetailResponse(),
        param.toMap(), QueryMutation().queryConversationByContactNumber());
  }

  Future<Resources> doRecordingApiCall(
      ConversationDetailRequestHolder param) async {
    return await mServerCallMutationWithAuth(
        param.toMap(), QueryMutation().queryRecordingByContactNumber());
  }

  Future<Stream<QueryResult>> doSubscriptionUpdateConversationDetail(
      SubscriptionUpdateConversationDetailRequestHolder jsonMap) async {
    return await subscriptionUpdateConversationDetail<
            SubscriptionConversationDetailResponse,
            SubscriptionConversationDetailResponse>(
        SubscriptionConversationDetailResponse(),
        jsonMap.toMap(),
        QueryMutation().subscriptionUpdateConversationDetail());
  }

  Future<Stream<QueryResult>> doSubscriptionOnlineMemberStatus(
      String workspace) async {
    return await subscriptionOnlineMemberStatusDetail<
            SubscriptionOnlineMemberStatusResponse,
            SubscriptionOnlineMemberStatusResponse>(
        SubscriptionOnlineMemberStatusResponse(),
        {"workspace": workspace},
        QueryMutation().subscriptionOnlineMemberStatus());
  }




  Future<Resources<ClientDndResponse>>
      doRequestToMuteConversationByClientNumber(
          UpdateClientDNDRequestParamHolder paramHolder) async {
    return await doServerCallQueryWithAuthQueryAndVariable<ClientDndResponse,
        ClientDndResponse>(
      ClientDndResponse(),
      QueryMutation().mutationUpdateClientDnd(),
      CommonRequestHolder(data: paramHolder.toMap()).toMap(),
    );
  }

  Future<Resources<ChannelResponse>> doGetChannelsCall() async {
    return await doServerCallQueryWithCallAccessToken<ChannelResponse,
        ChannelResponse>(ChannelResponse(), QueryMutation().getChannels());
  }

  Future<Resources<CallRecordResponse>> callRecord(
      Map<String, dynamic> jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<CallRecordResponse,
        CallRecordResponse>(
      CallRecordResponse(),
      QueryMutation().callRecord(),
      CommonRequestHolder(data: jsonMap).toMap(),
    );
  }

  Future<Resources<MembersResponse>> doGetAllWorkspaceMembersApiCall(
      PageRequestHolder param) async {
    Resources<MembersResponse> data =
        await doServerCallQueryWithAuthQueryAndVairable(
      MembersResponse(),
      QueryMutation().queryGetAllWorkSpaceMembers(),
      param.toMap(),
    );
    return data;
  }

  Future<Resources<ConversationDetailResponse>> searchConversationApiCall(
      SearchConversationRequestHolder param) async {
    return await doServerCallMutationWithAuth<ConversationDetailResponse,
            ConversationDetailResponse>(ConversationDetailResponse(),
        param.toMap(), QueryMutation().queryConversationByContactNumber());
  }

  Future<Resources<ConversationDetailResponse>>
      searchConversationWithCursorApiCall(
          ConversationDetailRequestHolder param) async {
    return await doServerCallMutationWithAuth<ConversationDetailResponse,
            ConversationDetailResponse>(ConversationDetailResponse(),
        param.toMap(), QueryMutation().queryConversationByContactNumber());
  }

  Future<Resources<AddNoteResponse>> doAddNoteToContactApiCall(
      AddNoteToContactRequestHolder jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<AddNoteResponse,
        AddNoteResponse>(
      AddNoteResponse(),
      QueryMutation().mutationAddNoteToContact(),
      jsonMap.toMap(),
    );
  }

  Future<Resources<AddNoteByNumberResponse>> doAddNoteByNumberApiCall(
      AddNoteByNumberRequestHolder jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<
        AddNoteByNumberResponse, AddNoteByNumberResponse>(
      AddNoteByNumberResponse(),
      QueryMutation().mutationAddNoteByNumber(),
      jsonMap.toMap(),
    );
  }

  Future<Resources<ResponseData>> transferCall(
      Map<String, dynamic> param) async {
    return await doServerCallQueryWithAuthQueryAndVariable<ResponseData,
        ResponseData>(
      ResponseData(),
      QueryMutation().transferCall(),
      param,
    );
  }

  Future<Resources<OnlineStatusResponse>> onlineStatus(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallMutationWithApiAuth<OnlineStatusResponse,
        OnlineStatusResponse>(
      OnlineStatusResponse(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().updateOnlineStatus(),
    );
  }

  Future<Resources<InviteMemberResponse>> inviteUserToWorkSpace(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<InviteMemberResponse,
        InviteMemberResponse>(
      InviteMemberResponse(),
      QueryMutation().inviteMember(),
      CommonRequestHolder(data: jsonMap).toMap(),
    );
  }

  Future<Resources<AddWorkSpaceResponse>> doAddWorkSpaceApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallMutationWithApiAuth<AddWorkSpaceResponse,
        AddWorkSpaceResponse>(
      AddWorkSpaceResponse(),
      CommonRequestHolder(data: jsonMap).toMap(),
      QueryMutation().mutationAddNewWorkSpace(),
    );
  }

  Future<Resources<TeamsResponse>> getTeamList(
      Map<String, dynamic> jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<TeamsResponse,
        TeamsResponse>(
      TeamsResponse(),
      QueryMutation().queryTeams(),
      jsonMap,
    );
  }

  Future<Resources<NumberResponse>> getMyNumbers() async {
    return await doServerCallQueryWithCallAccessToken<NumberResponse,
        NumberResponse>(
      NumberResponse(),
      QueryMutation().queryMyNumbers(),
    );
  }

  Future<Resources<OverviewResponse>> doOverViewDetailsApiCall() async {
    return await doServerCallQueryWithCallAccessToken<OverviewResponse,
        OverviewResponse>(
      OverviewResponse(),
      QueryMutation().planOverView(),
    );
  }

  Future<Resources<WorkspaceListResponse>> getWorkSpaceList() async {
    return await doServerCallQueryWithAuth<WorkspaceListResponse,
        WorkspaceListResponse>(
      WorkspaceListResponse(),
      QueryMutation().queryWorkSpaces(),
    );
  }

  Future<Resources<AddTeamResponse>> doAddTeamApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<AddTeamResponse,
        AddTeamResponse>(
      AddTeamResponse(),
      QueryMutation().queryAddTeam(),
      CommonRequestHolder(data: jsonMap).toMap(),
    );
  }

  Future<Resources<UploadWorkSpaceImageResponse>> doUploadWorkSpaceImageApiCall(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallQueryWithAuthQueryAndVariable<
            UploadWorkSpaceImageResponse, UploadWorkSpaceImageResponse>(
        UploadWorkSpaceImageResponse(),
        QueryMutation().changeWorkSpacePhoto(),
        jsonMap);
  }

  Future<Resources<RefreshTokenResponse>> doRefreshTokenApiCall() async {
    return await doServerCallQueryWithRefreshToken<RefreshTokenResponse,
        RefreshTokenResponse>(
      RefreshTokenResponse(),
      QueryMutation().mutationRefreshToken(),
    );
  }

  Future<Resources<ArchiveWorkSpaceResponse>> doArchiveWorkSpaceApiCall(
      Map<String, dynamic> map) async {
    return await doServerCallQueryWithAuthQueryAndVariable<
        ArchiveWorkSpaceResponse, ArchiveWorkSpaceResponse>(
      ArchiveWorkSpaceResponse(),
      QueryMutation().archiveWorkSpace(),
      map,
    );
  }

  Future<Resources<RestoreWorkspaceResponse>> doRestoreWorkSpaceApiCall(
      Map<String, dynamic> map) async {
    return await doServerCallQueryWithAuthQueryAndVariable<
        RestoreWorkspaceResponse, RestoreWorkspaceResponse>(
      RestoreWorkspaceResponse(),
      QueryMutation().restoreWorkSpace(),
      map,
    );
  }

  Future<Resources<EditTagResponse>> postEditAddTagsTitle(
      Map<dynamic, dynamic> jsonMap) async {
    return await doServerCallMutationWithAuth<EditTagResponse, EditTagResponse>(
      EditTagResponse(),
      jsonMap,
      QueryMutation().editTag(),
    );
  }
}
