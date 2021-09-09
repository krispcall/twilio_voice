import 'package:flutter/material.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/ui/app_info/AppInfoView.dart';
import 'package:voice_example/ui/contacts/contact_add/ContactAddView.dart';
import 'package:voice_example/ui/contacts/contact_individual_detail_edit/ContactIndivdualDetailEdit.dart';
import 'package:voice_example/ui/dashboard/DashboardView.dart';
import 'package:voice_example/ui/get_started/GetStarted.dart';
import 'package:voice_example/ui/members/MemberListViewWidget.dart';
import 'package:voice_example/ui/message/message_detail/MessageDetailView.dart' as MessageDetailView;
import 'package:voice_example/ui/notes/AddNotesView.dart';
import 'package:voice_example/ui/notes/NotesListView.dart';
import 'package:voice_example/ui/number/NumberListView.dart';
import 'package:voice_example/ui/overview/OverViewWidget.dart';
import 'package:voice_example/ui/message/conversation_search/ConversationSearchView.dart';
import 'package:voice_example/ui/recording/RecordingView.dart';
import 'package:voice_example/ui/tag/AddGlobalTag.dart';
import 'package:voice_example/ui/tag/AddNewTagView.dart';
import 'package:voice_example/ui/tag/TagListView.dart';
import 'package:voice_example/ui/tag/edit/EditTagContainerView.dart';
import 'package:voice_example/ui/teams/TeamsListWidget.dart';
import 'package:voice_example/ui/user/edit_profile/EditProfileView.dart';
import 'package:voice_example/ui/members/add/AddNewMemberView.dart';
import 'package:voice_example/ui/teams/create/CreateNewTeamView.dart';
import 'package:voice_example/ui/user/login/LoginView.dart';
import 'package:voice_example/ui/workspace/create/CreateNewWorkSpaceView.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddGlobalTagViewHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddNotesIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddNewMemberIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddTagIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddWorkSpaceIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/CreateNewTeamIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/EditContactIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/MemberListIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/NumberListIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/SearchConversationIntenHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/TagIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddContactIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/EditProfileIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/MessageDetailIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/TeamListIntentHolder.dart';

final routes = {
  '/': (context) => AppInfoView(),
  RoutePaths.home: (context) => DashboardView(),
  RoutePaths.getStarted: (context) => GetStarted(),
  RoutePaths.loginView: (context) => LoginView(),
  RoutePaths.editProfile: (context) => EditProfileView(
    phoneNumber: (ModalRoute.of(context).settings.arguments as EditProfileIntentHolder).phoneNumber,
    selectedCountryCode: (ModalRoute.of(context).settings.arguments as EditProfileIntentHolder).selectedCountryCode,
    email: (ModalRoute.of(context).settings.arguments as EditProfileIntentHolder).email,
    name: (ModalRoute.of(context).settings.arguments as EditProfileIntentHolder).name,
    callback: (ModalRoute.of(context).settings.arguments as EditProfileIntentHolder).onSuccess,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as EditProfileIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as EditProfileIntentHolder).onOutgoingTap,
  ),
  RoutePaths.newContact: (context) => ContactAddView(
    defaultCountryCode: (ModalRoute.of(context).settings.arguments as AddContactIntentHolder).defaultCountryCode,
    phoneNumber: (ModalRoute.of(context).settings.arguments as AddContactIntentHolder).phoneNumber,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as AddContactIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as AddContactIntentHolder).onOutgoingTap,
  ),
  RoutePaths.editContact: (context) => ContactIndividualDetailEditView(
    editName: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).editName,
    contactName: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).contactName,
    contactNumber: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).contactNumber,
    email: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).email,
    company: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).company,
    address: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).address,
    visibility: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).visibility,
    photoUpload: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).photoUpload,
    tags: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).tags,
    id: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).id,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as EditContactIntentHolder).onOutgoingTap,
  ),
  RoutePaths.messageDetail: (context) => MessageDetailView.MessageDetailView(
    clientId: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).clientId,
    clientName: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).clientName,
    clientPhoneNumber: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).clientPhoneNumber,
    countryId: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).countryId,
    countryFlagUrl: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).countryFlagUrl,
    clientProfilePicture: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).clientProfilePicture,
    lastChatted: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).lastChatted,
    isBlocked: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).isBlocked,
    dndMissed: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).dndMissed,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).onOutgoingTap,
    makeCallWithSid: (ModalRoute.of(context).settings.arguments as MessageDetailIntentHolder).makeCallWithSid,
  ),
  RoutePaths.recordingView: (context) => RecordingView(
        clientId: (ModalRoute.of(context).settings.arguments
                as MessageDetailIntentHolder)
            .clientId,
        clientName: (ModalRoute.of(context).settings.arguments
                as MessageDetailIntentHolder)
            .clientName,
        clientPhoneNumber: (ModalRoute.of(context).settings.arguments
                as MessageDetailIntentHolder)
            .clientPhoneNumber,
        clientProfilePicture: (ModalRoute.of(context).settings.arguments
                as MessageDetailIntentHolder)
            .clientProfilePicture,
      ),
  RoutePaths.searchConversation: (context) => ConversationSearchView(
      contactNumber: (ModalRoute.of(context).settings.arguments
              as SearchConversationIntentHolder)
          .contactNumber,
      contactName: (ModalRoute.of(context).settings.arguments
              as SearchConversationIntentHolder)
          .contactName,
      animationController: (ModalRoute.of(context).settings.arguments
              as SearchConversationIntentHolder)
          .animationController),
  RoutePaths.addNewTag: (context) => AddTagViewWidget(
    clientId: (ModalRoute.of(context).settings.arguments as AddTagIntentHolder).clientId,
    clientNumber: (ModalRoute.of(context).settings.arguments as AddTagIntentHolder).number,
    countryId: (ModalRoute.of(context).settings.arguments as AddTagIntentHolder).countryId,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as AddTagIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as AddTagIntentHolder).onOutgoingTap,
  ),
  RoutePaths.algebra: (context) => EditTagContainerView(
    tag: (ModalRoute.of(context).settings.arguments as TagsIntentHolder).tag,
    callBack: (ModalRoute.of(context).settings.arguments as TagsIntentHolder).onCallBack,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as TagsIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as TagsIntentHolder).onOutgoingTap,
  ),
  RoutePaths.notesList: (context) => NotesListView(
    clientId: (ModalRoute.of(context).settings.arguments as AddNotesIntentHolder).clientId,
    clientNumber: (ModalRoute.of(context).settings.arguments as AddNotesIntentHolder).number,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as AddNotesIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as AddNotesIntentHolder).onOutgoingTap,
  ),
  RoutePaths.addNewNotes: (context) => AddNotesView(
    clientId: (ModalRoute.of(context).settings.arguments as AddNotesIntentHolder).clientId,
    clientNumber: (ModalRoute.of(context).settings.arguments as AddNotesIntentHolder).number,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as AddNotesIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as AddNotesIntentHolder).onOutgoingTap,
  ),
  RoutePaths.addGlobalTag: (context) => AddGlobalTagView(
    workspaceName: (ModalRoute.of(context).settings.arguments as AddGlobalTagViewHolder).workspaceName,
    workSpaceImage: (ModalRoute.of(context).settings.arguments as AddGlobalTagViewHolder).workspaceImage,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as AddGlobalTagViewHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as AddGlobalTagViewHolder).onOutgoingTap,
    onCallback: (ModalRoute.of(context).settings.arguments as AddGlobalTagViewHolder).onCallBack,
  ),
  RoutePaths.tagsList: (context) => TagsListView(
    workspaceName: (ModalRoute.of(context).settings.arguments as AddGlobalTagViewHolder).workspaceName,
    workSpaceImage: (ModalRoute.of(context).settings.arguments as AddGlobalTagViewHolder).workspaceImage,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as AddGlobalTagViewHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as AddGlobalTagViewHolder).onOutgoingTap,
  ),
  RoutePaths.teamsList: (context) => TeamListWidget(
    onIncomingTap: (ModalRoute.of(context).settings.arguments as TeamListIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as TeamListIntentHolder).onOutgoingTap,
  ),
  RoutePaths.myNumbers: (context) => NumberListView(
    onIncomingTap: (ModalRoute.of(context).settings.arguments as NumberListIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as NumberListIntentHolder).onOutgoingTap,
  ),
  RoutePaths.memberList: (context) => MemberListViewWidget(
    onIncomingTap: (ModalRoute.of(context).settings.arguments as MemberListIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as MemberListIntentHolder).onOutgoingTap,
  ),
  RoutePaths.overview: (context) => OverViewWidget(
    onCallBack: (ModalRoute.of(context).settings.arguments as AddWorkSpaceIntentHolder).onAddWorkSpaceCallBack,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as AddWorkSpaceIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as AddWorkSpaceIntentHolder).onOutgoingTap,
  ),
  RoutePaths.createWorkSpace: (context) => CreateNewWorkSpaceView(
    onCallBack: (ModalRoute.of(context).settings.arguments as AddWorkSpaceIntentHolder).onAddWorkSpaceCallBack,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as AddWorkSpaceIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as AddWorkSpaceIntentHolder).onOutgoingTap,
  ),
  RoutePaths.addTeams: (context) => CreateNewTeamView(
    onTeamCreated: (ModalRoute.of(context).settings.arguments as CreateNewTeamIntentHolder).onNewTeamCreated,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as CreateNewTeamIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as CreateNewTeamIntentHolder).onOutgoingTap,
  ),
  RoutePaths.addMember: (context) => AddNewMemberView(
    onAddToTeamTap: (ModalRoute.of(context).settings.arguments as AddNewMemberIntentHolder).onMemberSelected,
    onIncomingTap: (ModalRoute.of(context).settings.arguments as AddNewMemberIntentHolder).onIncomingTap,
    onOutgoingTap: (ModalRoute.of(context).settings.arguments as AddNewMemberIntentHolder).onOutgoingTap,
  ),
};
