class Chat {
  late String id, sender, receiver, message, messageType;
  late DateTime insertedOn;
  Chat(
      {required this.id,
      required this.sender,
      required this.receiver,
      required this.message,
      required this.insertedOn,
      this.messageType = 'text'});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String;
    sender = json['sender'] as String;
    receiver = json['receiver'] as String;
    message = json['message'] as String;
    insertedOn = DateTime.parse(json['insertedOn'] as String);
    messageType = json['messageType'] as String;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['insertedOn'] = insertedOn;
    data['messageType'] = messageType;
    return data;
  }
}
