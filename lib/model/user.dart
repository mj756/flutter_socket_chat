class User {
  late String id, name, profileImage;
  User({
    required this.id,
    required this.name,
    required this.profileImage,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    profileImage = json['profileImage'] as String;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profileImage'] = profileImage;
    return data;
  }
}
