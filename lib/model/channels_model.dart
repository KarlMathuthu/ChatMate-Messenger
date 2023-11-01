class ChannelsModel {
  final String channelName;
  final String channelUid;
  final String channelPhotoUrl;
  final String channelAdmin;
  final String channelTopic;
  final bool channelVerified;
  final String createDate;
  final List<String> channelMembers;
  final Map<String, dynamic> lastMessage;

  ChannelsModel({
    required this.channelName,
    required this.channelUid,
    required this.channelPhotoUrl,
    required this.channelTopic,
    required this.channelVerified,
    required this.channelMembers,
    required this.channelAdmin,
    required this.createDate,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      "channelName": channelName,
      "channelUid": channelUid,
      "channelPhotoUrl": channelPhotoUrl,
      "channelTopic": channelTopic,
      "channelAdmin": channelAdmin,
      "channelVerified": channelVerified,
      "channelMembers": channelMembers,
      "createDate": createDate,
      "lastMessage": lastMessage,
    };
  }
}
