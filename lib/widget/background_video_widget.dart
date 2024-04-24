// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class BackgroundVideoWidget extends StatefulWidget {
  const BackgroundVideoWidget({super.key});

  @override
  State<BackgroundVideoWidget> createState() => _BackgroundVideoWidgetState();
}

class _BackgroundVideoWidgetState extends State<BackgroundVideoWidget> {
  late final VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    videoController =
        VideoPlayerController.asset('assets/background/background.mp4')
          ..initialize().then((_) {
            videoController.play();
            videoController.setLooping(false);
          });
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(videoController);
  }
}
