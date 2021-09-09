import 'package:flutter/cupertino.dart';

class MessageDetailIntentHolder {
  const MessageDetailIntentHolder({
    @required this.clientId,
    @required this.clientPhoneNumber,
    @required this.clientName,
    @required this.clientProfilePicture,
    @required this.lastChatted,
    @required this.countryId,
    @required this.countryFlagUrl,
    @required this.isBlocked,
    @required this.dndMissed,
    @required this.isContact,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    @required this.makeCallWithSid,
  });

  final String clientId;
  final String clientPhoneNumber;
  final String clientName;
  final String clientProfilePicture;
  final String countryId;
  final String countryFlagUrl;
  final String lastChatted;
  final bool isBlocked;
  final bool dndMissed;
  final bool isContact;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String, String, String, String, String) makeCallWithSid;
}
