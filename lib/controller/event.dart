import 'package:event_bus/event_bus.dart';

EventBus eventHandler = EventBus();

class SingleMessageReceiveEvent {
  Map<String, dynamic> message;
  SingleMessageReceiveEvent({required this.message});
}

class MultipleMessageReceiveEvent {
  List<dynamic> messages;
  MultipleMessageReceiveEvent({required this.messages});
}

class GetAllMessageEvent {
  final String user1, user2;
  GetAllMessageEvent({required this.user1, required this.user2});
}

class SendMessageEvent {
  final Map<String, dynamic> message;
  SendMessageEvent({required this.message});
}

class SendGroupMessageEvent {
  final Map<String, dynamic> message;
  SendGroupMessageEvent({required this.message});
}

class GetGroupMessage {
  final String groupId;
  GetGroupMessage({required this.groupId});
}

class JoinRoom {
  JoinRoom();
}
