import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';

class DisplayVideo extends StatefulWidget {
  final String videoUrl;

  const DisplayVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<DisplayVideo> {
  late CachedVideoPlayerController controller;
  bool shouldPlay = false;

  @override
  void initState() {
    controller = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        controller.play();
        controller.setVolume(1);

        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(
                  children: [
                    CachedVideoPlayer(controller),
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          if (shouldPlay) {
                            controller.play();
                          } else {
                            controller.pause();
                          }

                          setState(() {
                            shouldPlay = !shouldPlay;
                          });
                        },
                        icon: Icon(shouldPlay ? Icons.play_circle : Icons.pause_circle),
                      ),
                    ),
                  ],
                ))
            : const Loader());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
