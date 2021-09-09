import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/provider/login_workspace/LoginWorkspaceProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addContactRequestParamHolder/AddContactRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNoteByNumberRequestParamHolder/AddNoteByNumberRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addTagRequestParamHolder/AddTagRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addTagsToContactRequestParamHolder/AddTagsToContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/editContactRequestHolder/EditContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactEdges.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactResponse.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/model/allNotes/Notes.dart';
import 'package:voice_example/viewobject/model/contactDetail/ContactDetailResponse.dart';

class ContactsProvider extends Provider
{
  ContactsProvider({
    @required ContactRepository contactRepository,
    this.valueHolder, int limit = 100
  }) : super(contactRepository, limit)
  {
    this.contactRepository = contactRepository;

    streamControllerContactEdges = StreamController<Resources<AllContactResponse>>.broadcast();
    subscriptionContactEdges = streamControllerContactEdges.stream.listen((Resources<AllContactResponse> resource)
    {
      _contactResponse = resource;

      if (resource.status != Status.BLOCK_LOADING && resource.status != Status.PROGRESS_LOADING)
      {
        isLoading = false;
      }

      if (!isDispose)
      {
        notifyListeners();
      }
    });

    streamControllerContactDetail = StreamController<Resources<ContactDetailResponse>>.broadcast();
    subscriptionContactDetail = streamControllerContactDetail.stream.listen((Resources<ContactDetailResponse> resource)
    {
      _contactDetailResponse = resource;


      if (resource!=null && resource.status != Status.BLOCK_LOADING && resource.status != Status.PROGRESS_LOADING)
      {
        isLoading = false;
      }

      if (!isDispose)
      {
        notifyListeners();
      }
    });

    streamControllerListTags = StreamController<Resources<List<Tags>>>.broadcast();
    subscriptionListTags = streamControllerListTags.stream.listen((Resources<List<Tags>> resource)
    {
      _tags = resource;

      if (resource.status != Status.BLOCK_LOADING && resource.status != Status.PROGRESS_LOADING)
      {
        isLoading = false;
      }

      if (!isDispose)
      {
        notifyListeners();
      }
    });

    streamControllerListNotes = StreamController<Resources<List<Notes>>>.broadcast();
    subscriptionListNotes = streamControllerListNotes.stream.listen((Resources<List<Notes>> resource)
    {
      _notes = resource;

      if (resource.status != Status.BLOCK_LOADING && resource.status != Status.PROGRESS_LOADING)
      {
        isLoading = false;
      }

      if (!isDispose)
      {
        notifyListeners();
      }
    });
  }

  ContactRepository contactRepository;
  ValueHolder valueHolder;
  LoginWorkspaceProvider loginWorkspaceProvider;

  StreamController<Resources<AllContactResponse>> streamControllerContactEdges;
  StreamSubscription<Resources<AllContactResponse>> subscriptionContactEdges;

  //DO THIS INSTEAD
  Resources<AllContactResponse> _contactResponse = Resources<AllContactResponse>(Status.NO_ACTION, '', null);

  //DONT DO THIS
  // Resources<AllContactResponse> _contactResponse = Resources<AllContactResponse>(Status.NO_ACTION, '', []);

  Resources<AllContactResponse> get contactResponse => _contactResponse;


  StreamController<Resources<ContactDetailResponse>> streamControllerContactDetail;
  StreamSubscription<Resources<ContactDetailResponse>> subscriptionContactDetail;

  Resources<ContactDetailResponse> _contactDetailResponse = Resources<ContactDetailResponse>(Status.NO_ACTION, '', null);
  Resources<ContactDetailResponse> get contactDetailResponse => _contactDetailResponse;

  StreamController<Resources<List<Tags>>> streamControllerListTags;
  StreamSubscription<Resources<List<Tags>>> subscriptionListTags;

  Resources<List<Tags>> _tags = Resources<List<Tags>>(Status.NO_ACTION, '', null);
  Resources<List<Tags>> get tags => _tags;

  StreamController<Resources<List<Notes>>> streamControllerListNotes;
  StreamSubscription<Resources<List<Notes>>> subscriptionListNotes;

  Resources<List<Notes>> _notes = Resources<List<Notes>>(Status.NO_ACTION, '', null);
  Resources<List<Notes>> get notes => _notes;

  @override
  void dispose()
  {
    streamControllerContactEdges.close();
    subscriptionContactEdges.cancel();

    streamControllerContactDetail.close();
    subscriptionContactDetail.cancel();

    streamControllerListTags.close();
    subscriptionListTags.cancel();

    streamControllerListNotes.close();
    subscriptionListNotes.cancel();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doAllContactApiCall() async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _contactResponse = await contactRepository.doAllContactApiCall(isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    if(!streamControllerContactEdges.isClosed)
    {
      streamControllerContactEdges.sink.add(_contactResponse);
    }
    return _contactResponse;
  }

Future<dynamic> doFilterApiContactByTagApiCall(String tag) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _contactResponse = await contactRepository.doFilterContactByTagApiCall(tag,isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    streamControllerContactEdges.sink.add(_contactResponse);
    return _contactResponse;
  }


  Future<dynamic> doContactDetailApiCall(String contactId) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _contactDetailResponse = await contactRepository.doContactDetailApiCall(contactId, isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    streamControllerContactDetail.sink.add(_contactDetailResponse);
    return _contactDetailResponse;
  }

  Future<dynamic> doAddContactsApiCall(AddContactRequestParamHolder jsonMap, File file) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return await contactRepository.doAddContactsApiCall(jsonMap, file, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> getAllContactsFromDB() async
  {
    Resources<List<AllContactEdges>> result = await contactRepository.getAllContactsFromDB();

    _contactResponse.data.contactResponse.contactResponseData.contactEdges.clear();
    _contactResponse.data.contactResponse.contactResponseData.contactEdges.addAll(result.data);
    streamControllerContactEdges.sink.add(_contactResponse);
    return _contactResponse.data.contactResponse.contactResponseData.contactEdges;
  }

  Future<dynamic> doSearchContactFromDb(String query) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<AllContactEdges>> result = await contactRepository.doSearchContactFromDb(query, isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    if(_contactResponse!=null && _contactResponse.data!=null)
    {
      _contactResponse.data.contactResponse.contactResponseData.contactEdges.clear();
      _contactResponse.data.contactResponse.contactResponseData.contactEdges.addAll(result.data);

      if(!streamControllerContactEdges.isClosed)
      {
        streamControllerContactEdges.sink.add(_contactResponse);
      }
      return _contactResponse.data.contactResponse.contactResponseData.contactEdges;
    }
  }

  Future<dynamic> putEditContacts(Map<dynamic, dynamic> jsonMap, String id) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await contactRepository.putEditContacts(jsonMap, id, isConnectedToInternet, Status.SUCCESS);
  }

  Future<dynamic> blockContacts(Map<dynamic, dynamic> jsonMap, String id) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await contactRepository.blockContacts(jsonMap, id, isConnectedToInternet, Status.SUCCESS);
  }

  Future<dynamic> deleteContact(var value) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await contactRepository.deleteContact(value, isConnectedToInternet, Status.SUCCESS);
  }

  Future<dynamic> doGetAllTagsApiCall() async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _tags = await contactRepository.doGetAllTagsApiCall(isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    if(contactDetailResponse.data!=null && contactDetailResponse.data.contactDetailResponseData.contacts!=null && contactDetailResponse.data.contactDetailResponseData.contacts.tags!=null && contactDetailResponse.data.contactDetailResponseData.contacts.tags.length!=0)
    {
      for(int i=0; i<contactDetailResponse.data.contactDetailResponseData.contacts.tags.length;i++)
      {
        for(int j=0;j<_tags.data.length;j++)
        {
          if(_tags.data[j].id==contactDetailResponse.data.contactDetailResponseData.contacts.tags[i].id)
          {
            _tags.data[j].check=true;
            contactDetailResponse.data.contactDetailResponseData.contacts.tags[i].check = true;
            break;
          }
        }
      }
    }
    streamControllerListTags.sink.add(_tags);
    return _tags;
  }

  Future<dynamic> doDbTagSearch(String text) async
  {
    _tags = await contactRepository.doDbTagSearch(text);
    streamControllerListTags.sink.add(_tags);
    return _tags;
  }

  Future<dynamic> doGetTagsFromDb() async
  {
    _tags = await contactRepository.doGetTagsFromDb();
    streamControllerListTags.sink.add(_tags);
    return _tags;
  }

  Future<dynamic> doAddNewTagApiCall(AddTagRequestParamHolder jsonMap) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return await contactRepository.doAddNewTagApiCall(jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> doEditContactApiCall(AddTagsToContactRequestHolder jsonMap) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return await contactRepository.doEditContactApiCall(jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> editContactApiCall(EditContactRequestHolder jsonMap) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return await contactRepository.editContactApiCall(jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> doAddNoteToContactApiCall(AddNoteToContactRequestHolder param) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await contactRepository.doAddNoteToContactApiCall(param, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> doAddNoteByNumberApiCall(AddNoteByNumberRequestHolder param) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await contactRepository.doAddNoteByNumberApiCall(param, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> doClientDndApiCall(UpdateClientDNDRequestParamHolder paramHolder) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return await contactRepository.doRequestForDndConversationByClientNumber(paramHolder, isConnectedToInternet, Status.PROGRESS_LOADING);
  }


  Future<dynamic> doGetAllNotesApiCall(ContactPinUnpinRequestHolder param) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _notes = await contactRepository.doGetAllNotesApiCall(param, isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    streamControllerListNotes.sink.add(_notes);
    return notes;
  }

  Future<dynamic> doEditTagTitleApiCall(Map<String,dynamic> jsonMap) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await contactRepository.doEditTagTitleApiCall(jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }
}
