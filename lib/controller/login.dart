import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learning/controller/preference_controller.dart';
import 'package:learning/controller/utility.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants/app_constant.dart';
import '../model/user.dart';
import '../view/home.dart';

class LoginController extends ChangeNotifier {
  late IO.Socket socket;
  bool isLogin = false;
  LoginController({required BuildContext context}) {
    socket = IO.io(
        AppConstant.serverAddress,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    socket.onConnect((_) {});
    socket.on('loginResult', (detail) {
      Map<String, dynamic> response = detail as Map<String, dynamic>;
      if (response['status'] == 0) {
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

  void login({required String email, required String password}) {
    try {
      socket.emit('loginRequest', {'email': email, 'password': password});
    } catch (e) {}
  }
}
