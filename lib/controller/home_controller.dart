import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:learning/controller/event.dart';
import 'package:learning/controller/preference_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants/app_constant.dart';
import '../model/user.dart';

class HomeController extends ChangeNotifier {
  late IO.Socket socket;
  List<User> users = List.empty(growable: true);
  HomeController() {
    socket = IO.io(
        'http://192.168.21.7:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    socket.onConnect((_) {
      socket.emit(
          'userReady',
          User.fromJson(json.decode(
              PreferenceController.getString(AppConstant.userPayload))));
    });
    socket.on('userList', (detail) {
      users.clear();
      if (detail != null) {
        for (var row in detail) {
          users.add(User.fromJson(row));
        }
        notifyListeners();
      }
    });
    socket.on('newUser', (detail) {
      final response = detail as Map<String, dynamic>;
      if (users
              .indexWhere((element) => element.id == response['id'] as String) <
          0) {
        users.add(User.fromJson(response));
        notifyListeners();
      }
    });
    socket.on('userLeave', (detail) {
      users.removeWhere((e) => e.id == detail['id']);
      notifyListeners();
    });
    socket.on('message', (detail) {
      if (detail != null) {
        eventHandler.fire(
            SingleMessageReceiveEvent(message: detail as Map<String, dynamic>));
      }
    });

    eventHandler.on<GetAllMessageEvent>().listen((event) {
      socket.emit('getMessage', {
        'user1': event.user1,
        'user2': event.user2,
      });
    });

    eventHandler.on<JoinRoom>().listen((event) {
      socket.emit('joinroom');
    });

    eventHandler.on<SendMessageEvent>().listen((event) {
      socket.emit('message', event.message);
    });

    eventHandler.on<SendGroupMessageEvent>().listen((event) {
      socket.emit('groupMessage', event.message);
    });

    socket.on('oldMessages', (detail) {
      if (detail != null) {
        eventHandler.fire(
            MultipleMessageReceiveEvent(messages: detail as List<dynamic>));
      }
    });
  }
}
