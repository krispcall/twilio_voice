import 'package:voice_example/db/CallLogDao.dart';
import 'package:voice_example/db/CallRecordingDao.dart';
import 'package:voice_example/db/ContactDetailDao.dart';
import 'package:voice_example/db/CountryDao.dart';
import 'package:voice_example/db/MemberDao.dart';
import 'package:voice_example/db/MessageDetailsDao.dart';
import 'package:voice_example/db/LoginWorkSpaceDao.dart';
import 'package:voice_example/db/NotesDao.dart';
import 'package:voice_example/db/NumberDao.dart';
import 'package:voice_example/db/RecentSearchDao.dart';
import 'package:voice_example/db/TagsDao.dart';
import 'package:voice_example/db/TeamDao.dart';
import 'package:voice_example/db/WorkSpaceDetailDao.dart';
import 'package:voice_example/repository/CallLogRepository.dart';
import 'package:voice_example/repository/CallRecordRepository.dart';
import 'package:voice_example/repository/CallTransferRepository.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/repository/LoginWorkspaceRepository.dart';
import 'package:voice_example/repository/MemberRepository.dart';
import 'package:voice_example/repository/MessageDetailsRepository.dart';
import 'package:voice_example/db/ContactDao.dart';
import 'package:voice_example/db/UserDao.dart';
import 'package:voice_example/repository/Common/NotificationRepository.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/repository/MyNumberRepository.dart';
import 'package:voice_example/repository/RecentSearchRepository.dart';
import 'package:voice_example/repository/RecordingRepository.dart';
import 'package:voice_example/repository/TeamsRepository.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/db/common/ps_shared_preferences.dart';
import 'package:voice_example/repository/AppInfoRepository.dart';
import 'package:voice_example/repository/LanguageRepository.dart';
import 'package:voice_example/repository/ThemeRepository.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = <SingleChildWidget>[
  ...independentProviders,
  ..._dependentProviders,
  ..._valueProviders,
];

List<SingleChildWidget> independentProviders = <SingleChildWidget>[
  Provider<PsSharedPreferences>.value(value: PsSharedPreferences.instance),
  Provider<ApiService>.value(value: ApiService()),
  Provider<UserDao>.value(value: UserDao.instance),
  Provider<ContactDao>.value(value: ContactDao.instance),
  Provider<MemberDao>.value(value: MemberDao.instance),
  Provider<MessageDetailsDao>.value(value: MessageDetailsDao.instance),
  Provider<CallLogDao>.value(value: CallLogDao.instance),
  Provider<LoginWorkSpaceDao>.value(value: LoginWorkSpaceDao.instance),
  Provider<WorkspaceDetailDao>.value(value: WorkspaceDetailDao.instance),
  Provider<CountryDao>.value(value: CountryDao.instance),
  Provider<TagsDao>.value(value: TagsDao.instance),
  Provider<NotesDao>.value(value: NotesDao.instance),
  Provider<ContactDetailDao>.value(value: ContactDetailDao.instance),
  Provider<RecentSearchDao>.value(value: RecentSearchDao.instance),
  Provider<TeamDao>.value(value: TeamDao.instance),
  Provider<NumberDao>.value(value: NumberDao.instance),
  Provider<CallRecordingDao>.value(value: CallRecordingDao.instance),
];

List<SingleChildWidget> _dependentProviders = <SingleChildWidget>[
  ProxyProvider<PsSharedPreferences, PsThemeRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            PsThemeRepository psThemeRepository) =>
        PsThemeRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider<ApiService, AppInfoRepository>(
    update: (_, ApiService apiService, AppInfoRepository appInfoRepository) =>
        AppInfoRepository(service: apiService),
  ),
  ProxyProvider<PsSharedPreferences, LanguageRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            LanguageRepository languageRepository) =>
        LanguageRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider<ApiService, NotificationRepository>(
    update: (_, ApiService apiService, NotificationRepository userRepository) =>
        NotificationRepository(
      service: apiService,
    ),
  ),
  ProxyProvider2<ApiService, MemberDao, MemberRepository>(
    update: (_, ApiService apiService, MemberDao messagesDao,
            MemberRepository memberRepository) =>
        MemberRepository(apiService: apiService, memberDao: messagesDao),
  ),
  ProxyProvider3<ApiService, MessageDetailsDao, CallRecordingDao,
      MessageDetailsRepository>(
    update: (_,
            ApiService apiService,
            MessageDetailsDao messagesDetailsDao,
            CallRecordingDao callRecordingDao,
            MessageDetailsRepository messagesRepository) =>
        MessageDetailsRepository(
            apiService: apiService,
            messageDetailsDao: messagesDetailsDao,
            callRecordingDao: callRecordingDao),
  ),
  ProxyProvider2<ApiService, CountryDao, CountryRepository>(
    update: (_, ApiService apiService, CountryDao countryDao,
            CountryRepository countryRepository) =>
        CountryRepository(apiService: apiService, countryDao: countryDao),
  ),
  ProxyProvider2<ApiService, CallLogDao, CallLogRepository>(
    update: (_, ApiService apiService, CallLogDao callLogsDao,
            CallLogRepository messagesRepository) =>
        CallLogRepository(apiService: apiService, callLogDao: callLogsDao),
  ),
  ProxyProvider2<ApiService, TeamDao, TeamRepository>(
    update: (_, ApiService apiService, TeamDao teamDao,
            TeamRepository repository) =>
        TeamRepository(apiService: apiService, teamDao: teamDao),
  ),
  ProxyProvider2<ApiService, NumberDao, MyNumberRepository>(
    update: (_, ApiService apiService, NumberDao numberDao,
            MyNumberRepository repository) =>
        MyNumberRepository(apiService: apiService, teamDao: numberDao),
  ),
  ProxyProvider5<ApiService, UserDao, LoginWorkSpaceDao, WorkspaceDetailDao, TeamDao,LoginWorkspaceRepository>(
    update: (_,
            ApiService apiService,
            UserDao userDao,
            LoginWorkSpaceDao loginWorkspaceDao,
            WorkspaceDetailDao workspaceDetailDao,
            TeamDao teamDao,
            LoginWorkspaceRepository loginWorkspaceRepository) =>
        LoginWorkspaceRepository(
      apiService: apiService,
      userDao: userDao,
      workSpaceDao: loginWorkspaceDao,
      teamDao: teamDao,
      workspaceDetailDao: workspaceDetailDao,
    ),
  ),
  ProxyProvider3<ApiService, UserDao, LoginWorkSpaceDao, UserRepository>(
    update: (_, ApiService apiService, UserDao userDao,
            LoginWorkSpaceDao workSpaceDao, UserRepository userRepository) =>
        UserRepository(
      service: apiService,
      userDao: userDao,
    ),
  ),
  ProxyProvider5<ApiService, ContactDao, ContactDetailDao, TagsDao, NotesDao,
      ContactRepository>(
    update: (_,
            ApiService apiService,
            ContactDao contactDao,
            ContactDetailDao contactDetailDao,
            TagsDao tagsDao,
            NotesDao notesDao,
            ContactRepository contactRepository) =>
        ContactRepository(
            apiService: apiService,
            contactDao: contactDao,
            contactDetailDao: contactDetailDao,
            tagsDao: tagsDao,
            notesDao: notesDao),
  ),
  ProxyProvider<ApiService, CallRecordRepository>(
    update:
        (_, ApiService apiService, CallRecordRepository callRecordRepository) =>
            CallRecordRepository(service: apiService),
  ),
  ProxyProvider<ApiService, CallTransferRepository>(
    update: (_, ApiService apiService,
            CallTransferRepository callRecordRepository) =>
        CallTransferRepository(service: apiService),
  ),
  ProxyProvider<RecentSearchDao, RecentSearchRepository>(
    update: (_, RecentSearchDao recentSearchDao,
            RecentSearchRepository recentSearchRepository) =>
        RecentSearchRepository(recentSearchDao: recentSearchDao),
  ),
  ProxyProvider2<ApiService, CallRecordingDao, RecordingRepository>(
    update: (_, ApiService apiService, CallRecordingDao callRecordingDao,
            RecordingRepository recordingRepository) =>
        RecordingRepository(
            apiService: apiService, callRecordingDao: callRecordingDao),
  ),
];

List<SingleChildWidget> _valueProviders = <SingleChildWidget>[
  StreamProvider<ValueHolder>(
    create: (BuildContext context) =>
        Provider.of<PsSharedPreferences>(context, listen: false).valueHolder,
  )
];
