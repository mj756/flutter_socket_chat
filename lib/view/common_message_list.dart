import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_constant.dart';
import '../controller/preference_controller.dart';
import '../model/chat.dart';
import '../model/user.dart';

class CommonMessageView extends StatelessWidget {
  final List<Chat> messages;
  CommonMessageView({super.key, required this.messages});
  final User currentUser = User.fromJson(
      json.decode(PreferenceController.getString(AppConstant.userPayload)));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          reverse: false,
          //  shrinkWrap: true,
          itemCount: messages.length,
          itemBuilder: (_, index) {
            final message = messages[index];
            return Align(
              alignment: message.sender != currentUser.id
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding:
                      EdgeInsets.all(message.messageType == 'text' ? 10 : 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: (message.messageType != 'text')
                      ? (message.messageType.contains('image')
                          ? CachedNetworkImage(
                              fadeOutDuration: const Duration(seconds: 1),
                              fadeInDuration: const Duration(seconds: 3),
                              imageUrl: message.message,
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                size: 30,
                              ),
                            )
                          : Row(
                              children: [
                                const Icon(
                                  Icons.download,
                                  size: 36,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                      message.message.substring(
                                        message.message.lastIndexOf('/') + 1,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.black)),
                                )
                              ],
                            ))
                      : Text(message.message,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black))),
            );
          }),
    );
  }
}
