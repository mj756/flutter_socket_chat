import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learning/controller/preference_controller.dart';
import 'package:learning/controller/utility.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants/app_constant.dart';
import '../model/user.dart';
import '../view/home.dart';

class RegisterController extends ChangeNotifier {
  late IO.Socket socket;
  bool isLogin = false;
  RegisterController({required BuildContext context}) {
    socket = IO.io(
        AppConstant.serverAddress,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    socket.onConnect((_) {});

    socket.on('registerResult', (detail) {
      Map<String, dynamic> response = detail as Map<String, dynamic>;
      if (response['status'] == 0) {
        response['data']['user']['id'] = response['data']['user']['_id'];
        final User user = User.fromJson(response['data']['user']);
        PreferenceController.setBoolean(AppConstant.isLoggedIn, true);
        PreferenceController.setString(AppConstant.userId, user.id);
        PreferenceController.setString(
            AppConstant.userPayload, json.encode(user.toJson()));
        socket.disconnect();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        Utility.showSnackBar(context, response['status']);
      }
    });
  }

  void register(
      {required String name, required String email, required String password}) {
    try {
      socket.emit('registerRequest',
          {'name': name, 'email': email, 'password': password});
    } catch (e) {}
  }
}
