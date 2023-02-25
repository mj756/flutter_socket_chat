import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learning/controller/home_controller.dart';
import 'package:learning/view/chatting_screen.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});
  @override
  Widget build(BuildContext context) {
    return context.watch<HomeController>().users.isEmpty
        ? Center(
            child: (Text('No any user is online at this moment',
                style: Theme.of(context).textTheme.bodyLarge)),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: context.watch<HomeController>().users.length,
            itemBuilder: (context, index) {
              final user = context.watch<HomeController>().users[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contexts) => ChattingScreen(
                                otherUser: context
                                    .watch<HomeController>()
                                    .users[index],
                              )));
                },
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(context
                      .watch<HomeController>()
                      .users[index]
                      .profileImage),
                ),
                title: Text(user.name),
              );
            });
  }
}
