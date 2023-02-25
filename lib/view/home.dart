import 'package:flutter/material.dart';
import 'package:learning/controller/home_controller.dart';
import 'package:learning/view/user_list.dart';
import 'package:provider/provider.dart';

import 'group_chat.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ChangeNotifierProvider(
          create: (_) => HomeController(),
          lazy: false,
          builder: (context, __) {
            return Scaffold(
                appBar: AppBar(
                  // toolbarHeight: 10,
                  centerTitle: true,
                  title: Text(
                    'Chatting app',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                  bottom: const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.person)),
                      Tab(icon: Icon(Icons.group)),
                    ],
                  ),
                ),
                body: const SafeArea(
                  child: TabBarView(
                    children: [
                      UserList(),
                      GroupChat(),
                    ],
                  ),
                ));
          }),
    );
  }
}
