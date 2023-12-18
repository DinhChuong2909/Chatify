class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imgURL;
  late DateTime lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imgURL,
    required this.lastActive,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> json) {
    return ChatUser(
      // json["name"] must have the same name in firebase because request json from firebase return the exact name from firebase
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      imgURL: json["image"],
      lastActive: json["last_active"].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "imgURL": imgURL,
      "last_active": lastActive,
    };
  }

  String lastDayActive() {
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
