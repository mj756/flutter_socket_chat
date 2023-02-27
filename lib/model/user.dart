class User {
  late String id, name, profileImage, email;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String;
    name = json['name'] as String;
    email = json['email'] as String;
    profileImage = json['profileImage'] as String;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['profileImage'] = profileImage;
    return data;
  }
}
