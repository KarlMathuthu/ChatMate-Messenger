class UserModel {
  final String userName;
  final String email;
  final String photoUrl;
  final String userUid;
  final String userBio;
  final String userStatus;
  final String fcmToken;
  final int strikes;
  final List<String> userTopics;

  UserModel({
    required this.userName,
    required this.email,
    required this.photoUrl,
    required this.userUid,
    required this.fcmToken,
    required this.userBio,
    required this.userStatus,
    required this.strikes,
    required this.userTopics,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'photoUrl': photoUrl,
      'userUid': userUid,
      'fcmToken': fcmToken,
      'userBio': userBio,
      'userStatus': userStatus,
      'strikes': strikes,
      'userTopics': userTopics,
    };
  }
}
