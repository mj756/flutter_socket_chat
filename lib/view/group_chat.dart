import 'package:flutter/material.dart';

import 'chatting_screen_group.dart';

class GroupChat extends StatelessWidget {
  const GroupChat({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => GroupChattingScreen())),
          child: const ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.abc),
            ),
            title: Text('Test group'),
          ),
        );
      },
    );
  }
}
