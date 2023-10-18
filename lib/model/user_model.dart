class UserModel {
  final String userName;
  final String email;
  final String photoUrl;
  final String userUid;

  UserModel({
    required this.userName,
    required this.email,
    required this.photoUrl,
    required this.userUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'photoUrl': photoUrl,
      'userUid': userUid,
    };
  }
}
