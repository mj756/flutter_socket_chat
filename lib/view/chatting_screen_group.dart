import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learning/controller/group_chatting_controller.dart';
import 'package:provider/provider.dart';

import '../constants/app_constant.dart';
import '../controller/preference_controller.dart';
import '../controller/utility.dart';
import '../model/user.dart';
import 'common_message_list.dart';

class GroupChattingScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  GroupChattingScreen({super.key});
  final User currentUser = User.fromJson(
      json.decode(PreferenceController.getString(AppConstant.userPayload)));
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => GroupChattingController(currentUserId: currentUser.id),
        lazy: false,
        builder: (context, __) {
          return Scaffold(
            appBar: AppBar(),
            body: Stack(
              children: [
                Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/chat_background.jpg'),
                            fit: BoxFit.fill)),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: CommonMessageView(
                      messages:
                          context.watch<GroupChattingController>().messages,
                    )),
                Positioned(
                  bottom: 0,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                fillColor: Colors.white,
                                hintText: 'Enter',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: InkWell(
                                    onTap: () async {
                                      await Utility.selectFile(context: context)
                                          .then((value) async {
                                        if (value.isNotEmpty) {
                                          await Provider.of<
                                                      GroupChattingController>(
                                                  context,
                                                  listen: false)
                                              .sendFile(filePath: value);
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.photo,
                                    )),
                                suffixIcon: InkWell(
                                    onTap: () {
                                      Provider.of<GroupChattingController>(
                                              context,
                                              listen: false)
                                          .sendMessage(
                                        message: _controller.text,
                                      );
                                      _controller.clear();
                                    },
                                    child: const Icon(
                                      Icons.send,
                                    ))),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
