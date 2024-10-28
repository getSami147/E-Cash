import 'package:flutter/material.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/components/textfield.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/utils/widget.dart';

class MessageScreen extends StatefulWidget {
  var image, title;
  MessageScreen({this.image, this.title, super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leadingWidth: 20,
        title: ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(widget.image)),
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text(
            'Online',
            style: TextStyle(),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    text("showing all chats here"),
                    const Spacer(),
                    textField(
                      hint: "I am on the way...",
                      maxline: 1,
                      suffix: const Icon(
                        Icons.telegram,
                        size: size40,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
