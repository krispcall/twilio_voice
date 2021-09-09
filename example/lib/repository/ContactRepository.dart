import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/db/ContactDao.dart';
import 'package:voice_example/db/ContactDetailDao.dart';
import 'package:voice_example/db/NotesDao.dart';
import 'package:voice_example/db/TagsDao.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/request_holder/addContactRequestParamHolder/AddContactRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNoteByNumberRequestParamHolder/AddNoteByNumberRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addTagRequestParamHolder/AddTagRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addTagsToContactRequestParamHolder/AddTagsToContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/allContactRequestParamHolder/AllContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/allContactRequestParamHolder/AllContactRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/blockContactResponse/BlockContactResponse.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactDetailRequestParamHolder/ContactDetailRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/editContactRequestHolder/EditContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart';
import 'package:voice_example/viewobject/model/addContact/AddContactResponse.dart';
import 'package:voice_example/viewobject/model/addNoteByNumber/AddNoteByNumberResponse.dart';
import 'package:voice_example/viewobject/model/addNotes/AddNoteResponse.dart';
import 'package:voice_example/viewobject/model/addTag/AddTagResponse.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactEdges.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactResponse.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/model/allNotes/AllNotesResponse.dart';
import 'package:voice_example/viewobject/model/allTags/AllTagsResponse.dart';
import 'package:voice_example/viewobject/model/allTags/EditTagResponse.dart';
import 'package:voice_example/viewobject/model/clientDndResponse/ClientDndResponse.dart';
import 'package:voice_example/viewobject/model/contactDetail/ContactDetailResponse.dart';
import 'package:voice_example/viewobject/model/editContact/EditContactResponse.dart';
import 'package:voice_example/viewobject/model/pagination/PageInfo.dart';
import 'package:voice_example/viewobject/model/allContact/Contact.dart';
import 'package:sembast/sembast.dart';

class ContactRepository extends Repository {
  ContactRepository({
    @required ApiService apiService,
    @required ContactDao contactDao,
    @required ContactDetailDao contactDetailDao,
    @required TagsDao tagsDao,
    @required NotesDao notesDao,
  }) {
    this.apiService = apiService;
    this.contactDao = contactDao;
    this.contactDetailDao = contactDetailDao;
    this.tagsDao = tagsDao;
    this.notesDao = notesDao;
  }

  String primaryKey = 'id';
  ApiService apiService;
  ContactDao contactDao;
  ContactDetailDao contactDetailDao;
  TagsDao tagsDao;
  PageInfo pageInfo;
  NotesDao notesDao;

  Future<dynamic> doAllContactApiCall(
      bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<AllContactResponse> _resource =
          await apiService.doAllContactApiCall(
        AllContactRequestHolder(
            param: AllContactRequestParamHolder(
                first: limit, sort: "name", order: "asc")),
      );

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.contactResponse.error == null) {
          await contactDao.deleteAll();
          await contactDao.insertAll(primaryKey,
              _resource.data.contactResponse.contactResponseData.contactEdges);
          return Resources(Status.SUCCESS, "", _resource.data);
        } else {
          return Resources(
              Status.ERROR, _resource.data.contactResponse.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    }
  }

  Future<dynamic> doFilterContactByTagApiCall(
      String tag, bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<AllContactResponse> _resource =
          await apiService.doAllContactApiCall(
        AllContactRequestHolder(
            param: AllContactRequestParamHolder(
              first: limit,
            ),
            tags: tag),
      );

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.contactResponse.error == null) {
          await contactDao.deleteAll();
          await contactDao.insertAll(primaryKey,
              _resource.data.contactResponse.contactResponseData.contactEdges);
          return Resources(Status.SUCCESS, "", _resource.data);
        } else {
          return Resources(
              Status.ERROR, _resource.data.contactResponse.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    }
  }

  Future<dynamic> doContactDetailApiCall(
      String uid, bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<ContactDetailResponse> _resource =
          await apiService.doContactDetailApiCall(
        ContactDetailRequestParamHolder(
          uid: uid,
        ),
      );

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.contactDetailResponseData.error == null) {
          await contactDetailDao.deleteAll();
          await contactDetailDao.insert(
              primaryKey, _resource.data.contactDetailResponseData.contacts);
          return Resources(Status.SUCCESS, "", _resource.data);
        } else {
          return Resources(Status.ERROR,
              _resource.data.contactDetailResponseData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    }
  }

  Future<dynamic> doGetAllTagsApiCall(
      bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<AllTagsResponse> _resource =
          await apiService.doGetAllTagsApiCall();

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.allTagsResponseData.error == null) {
          await tagsDao.deleteAll();
          await tagsDao.insertAll(
              primaryKey, _resource.data.allTagsResponseData.listTags);
          return Resources(
              Status.SUCCESS, "", _resource.data.allTagsResponseData.listTags);
        } else {
          return Resources(Status.ERROR,
              _resource.data.allTagsResponseData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    }
  }

  Future<dynamic> doAddNewTagApiCall(AddTagRequestParamHolder jsonMap,
      bool isConnectedToInternet, Status isLoading) async {
    if (isConnectedToInternet) {
      final Resources<AddTagResponse> _resource =
          await apiService.doAddNewTagApiCall(jsonMap);
      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.addTagsResponseData != null &&
            _resource.data.addTagsResponseData.error == null) {
          return Resources(Status.SUCCESS, "", _resource.data);
        } else {
          return Resources(Status.ERROR,
              _resource.data.addTagsResponseData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    }
  }

  Future<dynamic> doEditContactApiCall(AddTagsToContactRequestHolder jsonMap,
      bool isConnectedToInternet, Status isLoading) async {
    if (isConnectedToInternet) {
      final Resources<EditContactResponse> _resource =
          await apiService.doEditContactApiCall(jsonMap);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.editContactResponseData.error == null) {
          return Resources(Status.SUCCESS, "", _resource.data);
        } else {
          return Resources(Status.ERROR,
              _resource.data.editContactResponseData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    }
  }

  Future<dynamic> editContactApiCall(EditContactRequestHolder jsonMap,
      bool isConnectedToInternet, Status isLoading) async {
    if (isConnectedToInternet) {
      final Resources<EditContactResponse> _resource =
          await apiService.editContactApiCall(jsonMap);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.editContactResponseData.error == null) {
          return Resources(Status.SUCCESS, "", _resource.data);
        } else {
          return Resources(Status.ERROR,
              _resource.data.editContactResponseData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    }
  }

  Future<Resources<List<AllContactEdges>>> getAllContactsFromDB() async {
    Resources<List<AllContactEdges>> result = await contactDao.getAll();
    return result;
  }

  Future<dynamic> doSearchContactFromDb(
      String query, bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    Filter filter;
    if (query.contains("+")) {
      filter = Filter.matchesRegExp(
          'node.number', RegExp("\\" + query, caseSensitive: false));
    } else {
      filter = Filter.matchesRegExp(
          'node.name', RegExp(query, caseSensitive: false));
    }
    Finder finder = Finder(filter: filter);
    Resources<List<AllContactEdges>> result =
        await contactDao.getAll(finder: finder);
    return result;
  }

  Future<Resources<AddContactResponse>> doAddContactsApiCall(
      AddContactRequestParamHolder jsonMap,
      File file,
      bool isConnectedToInternet,
      Status success,
      {bool isLoadFromServer = true}) async {
    // final Resources<AddContactResponse> _resource = await apiService.doAddContactsApiCall(jsonMap,file);
    final Resources<AddContactResponse> _resource =
        await apiService.postAddContacts(jsonMap.toMap(), file);

    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.addContactResponseData.error == null) {
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(Status.ERROR,
            _resource.data.addContactResponseData.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<EditTagResponse>> doEditTagTitleApiCall(
      Map<String, dynamic> jsonMap, bool isConnectedToInternet, Status success,
      {bool isLoadFromServer = true}) async {
    // final Resources<AddContactResponse> _resource = await apiService.doAddContactsApiCall(jsonMap,file);
    final Resources<EditTagResponse> _resource =
        await apiService.postEditAddTagsTitle(jsonMap);

    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.editTagData.error == null) {
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(
            Status.ERROR, _resource.data.editTagData.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<EditContactResponse>> putEditContacts(
      Map<dynamic, dynamic> jsonMap,
      String id,
      bool isConnectedToInternet,
      Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<EditContactResponse> _resource =
        await apiService.putEditContacts(jsonMap, id);
    return _resource;
  }

  Future<Resources<BlockContactResponse>> blockContacts(
      Map<dynamic, dynamic> jsonMap,
      String id,
      bool isConnectedToInternet,
      Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<BlockContactResponse> _resource =
        await apiService.blockContact(jsonMap, id);
    return _resource;
  }

  Future<Resources<DeleteContactResponse>> deleteContact(
      List<String> jsonMap, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<DeleteContactResponse> _resource =
        await apiService.deleteContact(jsonMap);
    if (_resource.status == Status.SUCCESS) {
      return _resource;
    } else {
      final Completer<Resources<dynamic>> completer =
          Completer<Resources<dynamic>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> doDbTagSearch(String text) async {
    Finder finder = Finder(
        filter:
            Filter.matchesRegExp('title', RegExp(text, caseSensitive: false)));
    Resources<List<Tags>> listTags = await tagsDao.getAll(finder: finder);
    return listTags;
  }

  Future<dynamic> doGetTagsFromDb() async {
    Resources<List<Tags>> listTags = await tagsDao.getAll();
    return listTags;
  }

  Future<dynamic> doAddNoteToContactApiCall(AddNoteToContactRequestHolder param,
      bool isConnectedToInternet, Status status) async {
    final Resources<AddNoteResponse> _resource =
        await apiService.doAddNoteToContactApiCall(param);

    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.addNoteResponseData.error == null) {
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(Status.ERROR,
            _resource.data.addNoteResponseData.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doAddNoteByNumberApiCall(AddNoteByNumberRequestHolder param,
      bool isConnectedToInternet, Status status) async {
    final Resources<AddNoteByNumberResponse> _resource =
        await apiService.doAddNoteByNumberApiCall(param);

    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.addNoteByNumberResponseData.error == null) {
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(Status.ERROR,
            _resource.data.addNoteByNumberResponseData.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doRequestForDndConversationByClientNumber(
      UpdateClientDNDRequestParamHolder paramHolder,
      bool isConnectedToInternet,
      Status status) async {
    Resources<ClientDndResponse> _resource =
        await apiService.doRequestToMuteConversationByClientNumber(paramHolder);

    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.clientDndResponseData.error == null) {
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(Status.ERROR,
            _resource.data.clientDndResponseData.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doGetAllNotesApiCall(ContactPinUnpinRequestHolder param,
      bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<AllNotesResponse> _resource =
          await apiService.doGetAllNotesApiCall(param);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.clientNotes.error == null) {
          await notesDao.deleteAll();
          await notesDao.insertAll(
              primaryKey, _resource.data.clientNotes.listNotes);
          return Resources(
              Status.SUCCESS, "", _resource.data.clientNotes.listNotes);
        } else {
          return Resources(
              Status.ERROR, _resource.data.clientNotes.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }
}
