class QueryMutation {
  String mutationLogin() {
    return """
      mutation login(\$data:LoginInputData!)
      {
        login(data:\$data)
        {
          status,
          data
          {
            token,
            details 
            {
              id,
              workspaces
              {
                id,
                memberId,
                title,
                role,
                photo,
                status
              },
              userProfile
              {
                 status
                 profilePicture,
                 firstname,
                 lastname,
                 email,
                 defaultLanguage,
                 defaultWorkspace,
                 stayOnline
              }
            }
          }
          error
          {
            code
            message
          }
        }
      }
    """;
  }

  String checkDuplicateLogin() {
    return """
      query checkDuplicateLogin(\$data:LoginInputData!)
      {
        checkDuplicateLogin(data:\$data)
        {
          status,
          data
          {
            success 
          }
          error
          {
            code
            message
          }
        }
      }
    """;
  }

  String mutationMemberLogin() {
    return """ 
    mutation memberLogin(\$data:MemberLoginInputData!) 
    {
      memberLogin(data: \$data)
      {
        status,
        data
        {
          accessToken,
          refreshToken,
        },
        error
        {
          code
          message
        }
      }
    }
    """;
  }

  String updateOnlineStatus() {
    return """ 
    mutation updateOnlineStatus(\$data: EditOnlineStatusInputData!) {
    updateOnlineStatus(data: \$data){
    status,
    error{
      message
    }
    data{
      id
      onlineStatus
      }
     }
   }
    """;
  }

  String queryVoiceToken() {
    return """
    query getVoiceToken(\$platform:Platform) {
      getVoiceToken(platform:\$platform) {
        status,
        error {
          code
          message
        }
        data {
          voiceToken
        }
      }
    }""";
  }

  String mutationCreateDeviceInfo() {
    return """
    mutation deviceRegister(\$data: DeviceRegisterInputData!) {
      deviceRegister(data: \$data){
        status,
        data{
          id,
          platform,
          fcmToken,
          version,
        },
        error{
          message,
          code,
        }
      }
    }""";
  }

  String mutationUnseenCount() {
    return """ 
      query unseenCount(\$channel: ShortId!) {
        unseenCount(channel: \$channel) {
          status
          data
          error {
            message
            code
            errorKey
          }
        }
      }
    """;
  }

  String mutationWorkspaceDetail() {
    return """ 
      query workspace {
        workspace{
          status,
          error{
            message
          }
          data{
            id,
            title,
            notification,
            photo,
            teams{
              id,
              name,
              online,
              total,
              picture
            }
            members{
              id,
              name,
              online,
              picture,
            }
            channels{
              id,
              name,
              number,
              countryCode,
              countryLogo,
              unseenMessageCount,
            },
            tags{
              id,
              title,
            }
          }
        }
      }
    """;
  }

  String mutationWorkspaceSwitch() {
    return """
      mutation (\$data:ChangeDefaultWorkspace!) {
        changeDefaultWorkspace(data:\$data){
          status,
          data{
            firstname,
            lastname,
            defaultLanguage,
            defaultWorkspace,
            profilePicture,
            email,
          },
          error{
            code,
            message
          }  
        }
      }
    """;
  }

  String queryGetAllWorkSpaceMembers() {
    return """
    query allWorkspaceMembers(\$pageParams: ConnectionInput!) 
    {
      allWorkspaceMembers(pageParams: \$pageParams) 
      {
        data 
        {
          edges
          {
            cursor,
            node 
            {
              id,
              role,
              gender,
              firstname,
              lastname,
              email,
              createdOn,
              online,
              profilePicture,
              onCall,
              numbers 
              {
                name,
                number,
                country,
                countryLogo,
                countryCode,
              },
            },
          },
          pageInfo 
          {
            startCursor,
            endCursor,
            hasNextPage,
            hasPreviousPage,
          },
        },
        error 
        {
          message,
          errorKey,
          code,
        },
        status,
      },
    }
    """;
  }

  String mutationCallAccessToken() {
    return """
      mutation memberLogin(\$data:MemberLoginInputData!) {
        memberLogin(data:\$data){
          status,
          data{
            accessToken,
            refreshToken
          }
          error{
            code
            message
          } 
        }
      }
    """;
  }

  String getUserProfileDetails() {
    return """
      query profile{
        profile{
          status,
          error{
            message
              }
          data{
            profilePicture,
            firstname,
            lastname,
            status,
            email,
            defaultLanguage,
            defaultWorkspace,
            stayOnline,
              }
          }
      }""";
  }

  String mutationEditProfileName() {
    return """mutation (\$data:ChangeProfileNames!) {
   changeProfileNames(data: \$data){
    status,
    data{
      firstname,
      lastname,
      defaultLanguage,
      defaultWorkspace,
      profilePicture,
      email,
    },
    error{
      code,
      message
         }
      }
  } """;
  }

  String mutationEditUserEmail() {
    return """mutation changeEmail(\$data: ChangeEmailInputData!) {
          changeEmail (data: \$data){
             status
             data {
                   success
                   }
                   error {
                   message
                   code
                   errorKey
                         }
          }
          } """;
  }

  String mutationUploadProfileImage() {
    return """mutation changeProfilePicture(\$photo_upload:Upload!) {
      changeProfilePicture(photoUpload:\$photo_upload){
        status,
        data{
          firstname,
          lastname,
          defaultLanguage,
          defaultWorkspace,
          profilePicture,
          email,
        },
        error{
          code,
          message
        }
      }
    }""";
  }

  String mutationChangePassword() {
    return """
    mutation changePassword(\$data:ChangePasswordInputData!) {
             changePassword(data: \$data){
                    status,
                    data{
                    success
                   },
             error{
                   code,
                   message,
                   errorKey
                  }
      }
    }""";
  }

/*query for getting all contacts*/

  /// TODO flag URL push in MVP
  String getAllContacts() {
    return """
    query contacts(\$params: ConnectionInput, \$tags:[ShortId]) 
    {
      contacts: contacts(params: \$params, tags: \$tags) 
      {
        data 
        {
          edges
          {
            cursor,
            node 
            {
              id,
              clientId,
              name,
              country,
              number,
              email,
              createdOn,
              visibility,
              address,
              blocked,
              flagUrl,
              profilePicture,
              tags
              {
                id,
                title,
                colorCode,
                backgroundColorCode,
              }, 
            },
          },
          pageInfo 
          {
            startCursor,
            endCursor,
            hasNextPage,
            hasPreviousPage,
          }
        },
        error 
        {
          message,
          errorKey,
          code,
        }
        status,
      }
    }
    """;
  }

  /// TODO flag URL push in MVP
  String queryContactDetail() {
    return """
    query contact(\$uid:ShortId!) 
    {
      contact(id:\$uid)
      {
        status,
        error{
          message
        },
        data{
          id,
          name,
          country,
          number,
          company,
          address,
          visibility,
          clientId,
          dndEnabled,
          dndEndtime,
          dndDuration,
          profilePicture,
          createdOn,
          blocked,
          email,
          flagUrl,
          tags{
            id,
            title,
            colorCode,
            backgroundColorCode,
          },
        }
      }
    }
    """;
  }

/*mututation for edit contacts*/
  String mutationEditContacts() {
    return '''mutation editContact(\$id: ShortId! ,\$data: EditContactInputData!) {
      editContact(data: \$data, id: \$id){
        status,
        data{
          id,
          country,
          name,
          address,
          company,
          number,
          visibility,
          email,
         tags{
          id,
          title,
          colorCode,
          backgroundColorCode,
        }
          notes{
            id,
            title
          }
        }
        error{
          message
          code
        }
        
      }
    }''';
  }

/*query for getting all contries*/
  String getAllCountries() {
    return '''query allCountries {
            allCountries{
                      status,
                      error{
                           message
                            }
                      data{
                            uid
                            dialingCode,
                            alphaTwoCode,
                            name,
                            flagUrl
                           }
                       }
    }''';
  }

/*mututation for adding new contacts*/
  String mutationAddNewContacts() {
    return '''
     mutation addContact(\$data: ContactInputData!) {
              addContact(data: \$data){
                         status,
                         data{
                              id,
                              country,
                              number,
                              email,
                              address,
                              visibility,
                              name,
                              notes{
                                   id,
                                   title
                                   }
                              tags{
                                   id,
                                  }
                             }
                         error{
                              message
                               code
                               }
    
              }
     }''';
  }

  /*mututation for delete contacts*/
  String mutationDeleteContacts() {
    return '''mutation deleteContacts(\$data: DeleteContactsInputData!) {
      deleteContacts(data: \$data){
            status,
            error{
                message
                 }
            data{
                success
                 }
      
             }
    
        }''';
  }

  /*Query for App Info*/
  String queryAppInfo()
  {
    return """ 
    query appRegisterInfo
    {
      appRegisterInfo
      {
        status,
        error
        {
          message
        }
        data
        {
          versionNo,
          versionForceUpdate,
          versionNeedClearData
        }
      }
    }
    """;
  }

  //Call Logs

  String queryCallLogs()
  {
    return """
    query recentConversation(\$channel: , ShortId!, \$params: ConnectionInput!)  
    {
      recentConversation(channel: \$channel, params: \$params)
      {
        status,
        data
        {
          pageInfo 
          {
            startCursor,
            endCursor,
            hasNextPage,
            hasPreviousPage,
          },
          edges 
          {
            cursor,
            node
            {
              id,
              createdAt,
              clientNumber,
              blocked,
              pinned,
              contactPinned,
              clientCountry,
              clientCountryFlag,
              conversationType,
              conversationStatus,
              clientProfilePicture,
              content
              {
                body,
              },
              direction,
              clientInfo
              {
                id,
                name,
                number,
                country,
                createdBy,
                profilePicture,
              },
            },
          },
        },
        error 
        {
          message,
          code,
          errorKey,
        }
      }
    }
    """;
  }

  String mutationPinConversationContact() {
    return """
    mutation addPinned(\$data: PinnedInputData!)
     {
       addPinned(data: \$data)
       {
        status,
        data
        {
          success
        },
        error
        {
          message,
          code,
        }
      }
    }
    """;
  }

  String queryConversationByContactNumber() {
    return """
    query conversation(\$channel: ShortId!, \$contact: String!, \$params: ConnectionInput) 
    {
      conversation(channel: \$channel, contact: \$contact, params: \$params) 
      {
        status,
        data 
        {
          pageInfo 
          {
            startCursor,
            endCursor,
            hasNextPage,
            hasPreviousPage,
          },
          edges 
          {
            cursor,
            node 
            {
              id,
              agentProfilePicture,
              clientNumber,
              channelNumber,
              clientCountry,
              clientProfilePicture,
              clientCountryFlag,
              status,
              channelCountry,
              createdAt,
              pinned,
              blocked,
              seen,
              content
              {
                duration,
                body,
              },
              conversationType,
              conversationStatus,
              direction,
              sms,
              contactPinned,
            },
          },
        },
        error 
        {
          message,
          code,
          errorKey,
        }
      }
    }
    """;
  }

  String queryRecordingByContactNumber() {
    return """
       query clientRecordings(\$channel: ShortId!, \$contact: String!, \$params: ConnectionInput) {
      clientRecordings(channel: \$channel, contact: \$contact, params: \$params) {
        status
        data {
          pageInfo {
            startCursor
            endCursor
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
             id
             createdAt
              seen
              content {
                body
                transferedAudio
                duration
                callDuration
              }
    
            }
          }
        }
        error {
          message
          code
          errorKey
        }
      }
    }
    """;
  }

  String queryNewCount() {
    return """
    query newCount(\$channel: ShortId!) {
    newCount(channel: \$channel) {
    status
    data
    error {
      message
      code
      errorKey
         }
     }
   }
    """;
  }

  String mutationSendNewMessage() {
    return """
    mutation sendMessage(\$data: ConversationInput!) 
    {
      sendMessage (data: \$data)
      {
        status,
        data 
        {
          id
          agentProfilePicture,
          clientNumber,
          channelNumber,
          clientCountry,
          clientProfilePicture,
          channelCountry,
          pinned,
          content 
          {
            body
          },
          conversationType,
          conversationStatus,
          direction,
        },
        error 
        {
          message,
          code,
          errorKey,
        }
      }
    }
    """;
  }

  String subscriptionUpdateConversationDetail() {
    return """
    subscription updateConversation(\$channel: ShortId!) 
    {
      updateConversation(channel: \$channel) 
      {
        event,
        message 
        {
          id,
          createdAt,
          clientNumber,
          blocked,
          clientCountry,
          clientCountryFlag,
          clientProfilePicture,
          dndMissed,
          favourite,
          seen,
          pinned,
          reject,
          conversationType,
          conversationStatus,
          content 
          {
            body,
            callDuration,
            callTime,
            duration,
            transferedAudio,
          },
          clientInfo 
          {
            id,
            name,
            country,
            createdBy,
            profilePicture,
            number,
          },
          direction,
        }
      } 
    }
  """;
  }

  String subscriptionOnlineMemberStatus() {
    return """
  subscription onlineMemberStatus(\$workspace: ShortId!) {
    onlineMemberStatus(workspace: \$workspace) {
      event,
      message {
        id,
        online,
      }
    }
  }
  """;
  }

  String getNewCount() {
    return """
  query newCount(\$channel: ShortId!) {
    newCount(channel: \$channel) {
        status,
        data,
        error{
          message
         code
       }
    }
  }
  """;
  }

  String getTags() {
    return """
    query contact {
    tags{
    status,
    error{
      message
    }
    data{
        id,
        title,
        colorCode,
        count,
        backgroundColorCode
      }
  }
  }""";
  }

  String queryGetAllTags() {
    return """
      query tags
      {
        tags{
          status,
          error{
            message
          }
         data{
          id,
          title,
          colorCode,
          backgroundColorCode,
          count
        }
      }
    }
    """;
  }

  String addTagsQuery() {
    return """
    mutation addTag(\$data: TagInputData!) 
    {
      addTag(data: \$data)
      {
        status,
         data{
           id,
           title,
           backgroundColorCode,
           colorCode
         }
        error{
          message
         code
       }
  }
}
   """;
  }

  String callRecord() {
    return """
    mutation callRecording(\$data: RecordCallInput!) {
    callRecording(data: \$data){
      status,
      data{
        status
    }
      error{
        message
        code
    }
  }
}
   """;
  }

  String mutationAddTagsToContact() {
    return """
    mutation editContact(\$id: ShortId! ,\$data: EditContactInputData!) 
    {
      editContact(data: \$data, id: \$id)
      {
        status,
        data
        {
          tags
          {
            id,
            title,
            colorCode,
            backgroundColorCode,
            count,
          },
          notes
          {
            id,
            title,
          },
        },
        error
        {
          message
          code
        },
      }
    }
   """;
  }

  /*client dnd*/
  String mutationUpdateClientDnd() {
    return """
    mutation updateClientDND(\$data: ClientDNDInput!)
    {
      updateClientDND(data: \$data)
      {
        status,
        data
        {
          id,
          email,
          name,
          createdOn,
          number,
          address,
          company,
          visibility,
          blocked,
          dndEnabled,
          dndDuration,
          createdBy,
          clientId,
          country,
          profilePicture
        }
        error
        {
          message,
          code,
        }
      }
    }
  """;
  }

  String blockContact() {
    return """
        mutation blockContact(\$uid:ShortId!, \$data:BlockContactInputData!) {
        blockContact(id:\$uid, data:\$data){
          status,
          error{
            message
            }
          data{
            id,
            blocked
            }
           }
          }
    """;
  }

  String getChannels() {
    return """ 
    query channels {
      channels {
      status
      data {
        id
    countryLogo
    country
    countryCode
    number
    name
    dndEndtime
    dndEnabled
    dndRemainingTime
    dndOn
    unseenMessageCount
      }
      error {
        code
    message
    errorKey
      }
    }
   }
    """;
  }

  String queryConversationSearch() {
    return """
    query conversation(\$channel: ShortId, \$contact: ShortId, \$params: ConnectionInput) {
  conversation(channel: \$channel, contact: \$contact, params: \$params) {
    status
    data {
      pageInfo {
        startCursor
        endCursor
        hasNextPage
        hasPreviousPage
      }
      edges {
        cursor
        node {
          id
          agentProfilePicture
          clientNumber
          channelNumber
          clientCountry
          clientName
          clientProfilePicture
          channelCountry
          createdAt
          content {
            body
            duration
          }
          conversationType
          conversationStatus
          direction
        }
      }
    }
    error {
      message
      code
      errorKey
    }
  }
}
    """;
  }

  String mutationAddNoteToContact() {
    return """
    mutation addNote(\$clientId:ShortId!, \$data: NoteInputData!) 
    {
      addNote(clientId:\$clientId, data: \$data)
      {
        status,
        error,
        {
          message,
          code,
        }
        data
        {
          title,
        },
      }   
    }
    """;
  }

  String mutationAddNoteByNumber() {
    return """
    mutation addNoteByContact(\$contact:String!, \$data: NoteInputData!)
    {
      addNoteByContact(contact:\$contact, data: \$data)
      {
        status,
        error,
        {
          message,
          code,
        }
        data
        {
          id,
          title,
          client
          {
            id,
            name,
            country,
            number,
            company,
            address,
            visibility,
            clientId,
            profilePicture,
            blocked,
            email,
            tags{
              id,
              title,
              colorCode,
              backgroundColorCode,
            },
          }
        },
      }   
    }
    """;
  }

  String transferCall() {
    return """
    query coldTransfer(\$data: TransferInput!) {
    coldTransfer(data: \$data) {
    status
    data
    error {
      message
      code
      errorKey
         }
     }
   }
    """;
  }

  String inviteMember() {
    return """
    mutation inviteMember(\$data:InviteMemberInputData!) {
    inviteMember(data: \$data){
    data{
      message
    },
    error{
      code,
      message
    }
   }
  }
    """;
  }

  String queryTeams() {
    return """
    query teams{
    teams{
       status,
    error{
      message
    }
      data{
        id,
        name,
        online,
        total,
        description,
        picture,
        teamMembers{
          id,
          firstname,
          lastname,
          online,
        }
      }
    }
  }
  """;
  }

  /*Todo need to add the countrylogo and countrycode after
  *  the numbers query is updated in backend  */
  // countryLogo
  // countryCode

  String queryMyNumbers() {
    return """
   query numbers {
    numbers{
    status
    data {
      id
      name
      number
      agents {
        id
        firstname
        lastname
        photo
      }
      callStrategy
      numberCheckoutPrice {
        setUpFee
        monthlyFee
      }
    }
    error {
      message
      errorKey
      code
    }
  }
  }
  """;
  }

  String planOverView() {
    return """
  query planOverview {
  planOverview{
    status
    data {
        customerId
        currentPeriodEnd
        hideKrispcallBranding
        dueAmount
        subscriptionActive
       card  {
        id
        name
        expiryMonth
        expiryYear
        brand
        lastDigit
       
      }
      credit {
        id
        amount
      }
      plan  {
        id
        title
        rate
      }
    }
    error {
      message
      errorKey
      code
    }
  }
}
  """;
  }

  String queryClientNotes() {
    return """
    query clientNotes(\$contact: String!, \$channel: ShortId!) 
    {
      clientNotes(contact:\$contact, channel: \$channel)
      {
        status,
        error
        {
          code,
          message,
        }
        data
        {
          id,
          title,
          createdAt,
          modifiedAt,
          userId,
          firstName,
          lastName,
          profilePicture,
        }
      }
    }
    """;
  }

  String queryWorkSpaces() {
    return """
 query workspaces {
  workspaces {
    status
    data {
      id
      photo
      memberId
      title
      status
      plan {
        cardInfo
        remainingDays,
        subscriptionActive,
        trialPeriod
       }
      
    }
    status
  }
}
    """;
  }

  String mutationAddNewWorkSpace() {
    /*Todo need to add*/
    // photo
    //role

    return """
    mutation addWorkspace(\$data: WorkspaceInputData!) {
    addWorkspace(data: \$data){
       status,
       data{
             id,
             memberId,
             title,
             }
       error{
       message
       code
           }
     }
  }
    """;
  }

  String queryAddTeam() {
    return """
    mutation addTeam(\$data: TeamInputData!) 
    {
      addTeam(data: \$data)
      {
        status,
        data
        {
          id,
          title,
          description,
          total,
          online,
          picture,
          teamMembers
          {
            id,
            firstname,
            lastname,
            profilePicture,
          }
        }
        error
        {
          message
          code
        }
      }
    }
    """;
  }

  String mutationRefreshToken() {
    return """
      mutation refreshToken
      {
        refreshToken
        {
          status,
          data
          {
            accessToken
          }
          error
          {
            code
            message
          }
        }
      }
    """;
  }

  String archiveWorkSpace() {
    return """
    mutation removeWorkspace(\$id: ShortId!) {
    removeWorkspace(id: \$id){
    status,
    error{
      message
    }
    data{
      id,
      title,
      photo,
      status,
          }
      }
    }
    """;
  }

  String restoreWorkSpace() {
    return """ 
    mutation restoreWorkspace(\$id: ShortId!) {
    restoreWorkspace(id: \$id){
   status,
    error{
      message
    }
    data{
      id,
      title,
      photo,
      status,
     }
      } 
    }
    """;
  }

  String editTag() {
    return """
    mutation editTag(\$id: ShortId!, \$data: EditTagInputData!) {
    editTag(data: \$data, id: \$id){
    status,
    data{
      id,
      title,
    }
    error{
      message
      code
    }
  }
  }
    """;
  }

  String changeWorkSpacePhoto() {
    return """
    mutation changeWorkspacePhoto(\$photoUpload: Upload!) {
   changeWorkspacePhoto(photoUpload: \$photoUpload) {
    status
    error {
      code
    }
    data {
      id
      title
      photo
    }
  }
}
    """;
  }
}
