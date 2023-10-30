class ChannelsModel {
  final String channelName;
  final String channelUid;
  final String channelPhotoUrl;
  final String channelAdmin;
  final bool channelVerified;
  final List<String> channelMembers;

  ChannelsModel({
    required this.channelName,
    required this.channelUid,
    required this.channelPhotoUrl,
    required this.channelVerified,
    required this.channelMembers,
    required this.channelAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      "channelName": channelName,
      "channelUid": channelUid,
      "channelPhotoUrl": channelPhotoUrl,
      "channelAdmin": channelAdmin,
      "channelVerified": channelVerified,
      "channelMembers": channelMembers,
    };
  }
}
