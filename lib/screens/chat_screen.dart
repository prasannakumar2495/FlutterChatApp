import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/widgets/chat/messages.dart';
import 'package:flutterchatapp/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                value: 'Logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Logout'),
                  ],
                ),
              ),
            ],
            onChanged: ((value) {
              if (value == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            }),
            iconEnabledColor: Theme.of(context).primaryIconTheme.color,
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: Messages(),
          ),
          NewMessages(),
        ],
      ),
    );
  }
}
