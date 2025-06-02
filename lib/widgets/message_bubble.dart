import 'package:flutter/material.dart';

// A MessageBubble for showing a single chat message on the ChatScreen.
class MessageBubble extends StatelessWidget {
  // Create a message bubble which is meant to be the first in the sequence.
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.createdAt,
    required this.usernameColor,
    required this.isMe,
  }) : isFirstInSequence = true;

  // Create a amessage bubble that continues the sequence.
  const MessageBubble.next({
    super.key,
    required this.message,
    required this.createdAt,
    required this.usernameColor,
    required this.isMe,
  }) : isFirstInSequence = false,
       userImage = null,
       username = null;

  // Whether or not this message bubble is the first in a sequence of messages
  // from the same user.
  // Modifies the message bubble slightly for these different cases - only
  // shows user image for the first message from the same user, and changes
  // the shape of the bubble for messages thereafter.
  final bool isFirstInSequence;

  // Image of the user to be displayed next to the bubble.
  // Not required if the message is not the first in a sequence.
  final String? userImage;

  // Username of the user.
  // Not required if the message is not the first in a sequence.
  final String? username;
  final String message;
  final String createdAt;
  final Color usernameColor;

  // Controls how the MessageBubble will be aligned.
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (isFirstInSequence)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.only(top: 12, bottom: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'August 8, 2023',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: userImage != null && !isMe ? true : false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Padding(
                padding: EdgeInsets.only(top: isFirstInSequence ? 12 : 0),
                child: CircleAvatar(
                  backgroundImage:
                      userImage != null && !isMe
                          ? NetworkImage(userImage!)
                          : null,
                  backgroundColor: theme.colorScheme.primary.withAlpha(180),
                  radius: 18,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 203, 203, 203),
                    blurStyle: BlurStyle.outer,
                    offset: Offset(0, 1),
                  ),
                ],
                color:
                    isMe
                        ? const Color.fromARGB(255, 179, 236, 201)
                        : const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft:
                      !isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(8),
                  topRight:
                      isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(8),
                  bottomLeft: const Radius.circular(8),
                  bottomRight: const Radius.circular(8),
                ),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: EdgeInsets.only(
                top: isFirstInSequence ? 12 : 2,
                left: 2,
                right: 2,
                bottom: 1,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (username != null && !isMe)
                    Text(
                      username!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: usernameColor,
                      ),
                    ),
                  if (isFirstInSequence && !isMe) const SizedBox(height: 4),

                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      final textSpan = TextSpan(
                        text: message,
                        style: TextStyle(
                          height: 1.3,
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                      final textPainter = TextPainter(
                        text: textSpan,
                        maxLines: null,
                        textDirection: TextDirection.ltr,
                      )..layout(
                        maxWidth:
                            isMe
                                ? constraints.maxWidth * 0.8
                                : constraints.maxWidth * 0.7,
                      );

                      final lineCount = textPainter.computeLineMetrics().length;

                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right:
                                  isMe
                                      ? lineCount == 1
                                          ? 64
                                          : 4
                                      : lineCount == 1
                                      ? 50
                                      : 4,
                              bottom: lineCount == 1 ? 0 : 18,
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  isMe
                                      ? constraints.maxWidth * 0.8
                                      : constraints.maxWidth * 0.7,
                            ),
                            child: Text(
                              message,
                              style: TextStyle(
                                height: 1.3,
                                color: Colors.grey[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Row(
                              children: [
                                Text(
                                  createdAt,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                  ),
                                ),
                                if (isMe) const SizedBox(width: 2),
                                if (isMe)
                                  Icon(
                                    Icons.done_all,
                                    color: Colors.grey[600],
                                    size: 14,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            // if (isMe) const SizedBox(width: 4),
            // if (isMe)
            //   Visibility(
            //     visible: userImage != null ? true : false,
            //     maintainSize: true,
            //     maintainAnimation: true,
            //     maintainState: true,
            //     child: CircleAvatar(
            //       backgroundImage:
            //           userImage != null ? NetworkImage(userImage!) : null,
            //       backgroundColor: theme.colorScheme.primary.withAlpha(180),
            //       radius: 18,
            //     ),
            //   ),
          ],
        ),
      ],
    );
  }
}
