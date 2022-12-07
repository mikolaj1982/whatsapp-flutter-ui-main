import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/enums/massage_enum.dart';

import 'display_video.dart';

class DisplayTextImageVideoGIF extends StatelessWidget {
  final String message; // url or text message
  final MessageEnum type;

  const DisplayTextImageVideoGIF({Key? key, required this.message, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.gif
            ? Image.network(message)
            : type == MessageEnum.image
                ? CachedNetworkImage(imageUrl: message)
                : type == MessageEnum.video
                    ? DisplayVideo(videoUrl: message)
                    : Container();
  }
}
