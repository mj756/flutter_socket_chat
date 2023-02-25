import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/constants/app_constant.dart';
import 'package:learning/controller/chatting.dart';
import 'package:learning/controller/preference_controller.dart';
import 'package:learning/view/common_message_list.dart';
import 'package:provider/provider.dart';

import '../controller/utility.dart';
import '../model/user.dart';

class ChattingScreen extends StatelessWidget {
  final User otherUser;
  final TextEditingController _controller = TextEditingController();
  ChattingScreen({super.key, required this.otherUser});
  final User currentUser = User.fromJson(
      json.decode(PreferenceController.getString(AppConstant.userPayload)));
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ChattingController(
            currentUserId: currentUser.id, otherUserId: otherUser.id),
        lazy: false,
        builder: (context, __) {
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              iconTheme: Theme.of(context).iconTheme,
              titleTextStyle: Theme.of(context).textTheme.bodyMedium,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      otherUser.profileImage,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    otherUser.name,
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/chat_background.jpg'),
                            fit: BoxFit.fill)),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: CommonMessageView(
                      messages: context.watch<ChattingController>().messages,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                                        await Utility.selectFile(
                                                context: context)
                                            .then((value) async {
                                          if (value.isNotEmpty) {
                                            await Provider.of<
                                                        ChattingController>(
                                                    context,
                                                    listen: false)
                                                .sendFile(filePath: value);
                                          }
                                        });
                                      },
                                      child: const Icon(
                                        Icons.photo,
                                        color: Colors.green,
                                      )),
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        Provider.of<ChattingController>(context,
                                                listen: false)
                                            .sendMessage(
                                          message: _controller.text,
                                        );
                                        _controller.clear();
                                      },
                                      child: const Icon(
                                        Icons.send,
                                        color: Colors.green,
                                      ))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
