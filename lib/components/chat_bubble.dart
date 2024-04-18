import 'package:flutter/services.dart';

import '../themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String type;
  final name;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.type,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    print(type.toString());
    // light vs dark mode for correct color bubble
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    if (type == 'text') {
      return Container(
        decoration: BoxDecoration(
            color: isCurrentUser
                ? (isDarkMode ? Colors.green.shade600 : Colors.grey.shade500)
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            borderRadius: isCurrentUser
                ? const BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12))
                : const BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
        child: name != null
            ? Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Text(
                    message,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              )
            : Text(
                message,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
      );
    } else {
      return Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w200,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      );
    }
    // else {
    //   return SizedBox();
    // }
  }
}
