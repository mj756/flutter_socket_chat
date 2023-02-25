import 'package:flutter/cupertino.dart';

import '../model/chat.dart';
import '../network/api_controller.dart';
import 'event.dart';

class GroupChattingController extends ChangeNotifier {
  List<Chat> messages = List.empty(growable: true);
  final String currentUserId;
  GroupChattingController({required this.currentUserId}) {
    eventHandler.on<MultipleMessageReceiveEvent>().listen((multipleMessage) {
      for (var row in multipleMessage.messages) {
        messages.add(Chat.fromJson(row));
      }
    });
    eventHandler.on<SingleMessageReceiveEvent>().listen((singleMessage) {
      messages.add(Chat.fromJson(singleMessage.message));
      notifyListeners();
    });
    eventHandler.fire(JoinRoom());
    eventHandler.fire(GetGroupMessage(groupId: ''));
  }
  Future<void> sendFile({required String filePath}) async {
    await ApiController().postFormData(
        url: 'http://192.168.21.7:3000/api/user/upload',
        params: {
          'sender': currentUserId,
          'receiver': 'sdkfjkdsj',
          'groupId': '',
          'messageType': 'file',
        },
        fileName: filePath);
  }

  void sendMessage({required String message}) {
    eventHandler.fire(SendGroupMessageEvent(message: {
      '_id': '',
      'sender': currentUserId,
      'receiver': '',
      'message': message,
      'messageType': 'text',
      'insertedOn': DateTime.now().toString(),
    }));

    messages.add(Chat(
        id: '',
        sender: currentUserId,
        receiver: '',
        message: message,
        messageType: 'text',
        insertedOn: DateTime.now()));
    notifyListeners();
  }
}
