import 'package:flutter/material.dart';
import 'package:learning/constants/app_constant.dart';
import 'package:learning/controller/event.dart';
import 'package:learning/network/api_controller.dart';

import '../model/chat.dart';

class ChattingController extends ChangeNotifier {
  List<Chat> messages = List.empty(growable: true);
  final String currentUserId, otherUserId;
  ChattingController({required this.currentUserId, required this.otherUserId}) {
    eventHandler.on<MultipleMessageReceiveEvent>().listen((multipleMessage) {
      for (var row in multipleMessage.messages) {
        messages.add(Chat.fromJson(row));
      }
      notifyListeners();
    });
    eventHandler.on<SingleMessageReceiveEvent>().listen((singleMessage) {
      messages.add(Chat.fromJson(singleMessage.message));
      notifyListeners();
    });
    eventHandler
        .fire(GetAllMessageEvent(user1: currentUserId, user2: otherUserId));
  }
  Future<void> sendFile({required String filePath}) async {
    await ApiController().postFormData(
        url: AppConstant.endpointFileUpload,
        params: {
          'sender': currentUserId,
          'receiver': otherUserId,
          'messageType': 'file',
        },
        fileName: filePath);
  }

  void sendMessage({required String message}) {
    eventHandler.fire(SendMessageEvent(message: {
      'sender': currentUserId,
      'receiver': otherUserId,
      'message': message,
    }));
    messages.add(Chat(
        id: '',
        sender: currentUserId,
        receiver: otherUserId,
        message: message,
        insertedOn: DateTime.now()));
    notifyListeners();
  }
}
