//maple_lingo_application/lib/widgets/chat_item.dart

import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatItem({
    super.key,
    required this.text,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ProfileContainer(isMe: isMe),
          if (!isMe) const SizedBox(width: 15),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.60,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(isMe ? 15 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 15),
                ),
              ),
              child: buildTextWidget(text, context),
            ),
          ),
          if (isMe) const SizedBox(width: 15),
          if (isMe) ProfileContainer(isMe: isMe),
        ],
      ),
    );
  }

  Widget buildTextWidget(String text, BuildContext context) {
    final List<InlineSpan> children = [];

    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final RegExp phoneticRegex = RegExp(r'\[(.*?)\]');

    text.splitMapJoin(
      boldRegex,
      onMatch: (Match match) {
        children.add(
          TextSpan(
            text: match.group(1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'YourPhoneticFontFamily',
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        );
        return '';
      },
      onNonMatch: (String nonMatch) {
        text.splitMapJoin(
          phoneticRegex,
          onMatch: (Match match) {
            children.add(
              TextSpan(
                text: match.group(1),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            );
            return '';
          },
          onNonMatch: (String nonMatch) {
            children.add(
              TextSpan(
                text: nonMatch,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            );
            return '';
          },
        );
        return '';
      },
    );

    return RichText(
      text: TextSpan(
        children: children,
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
    required this.isMe,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft: Radius.circular(isMe ? 0 : 15),
          bottomRight: Radius.circular(isMe ? 15 : 0),
        ),
      ),
      child: Icon(
        isMe ? Icons.person : Icons.phone_iphone,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
