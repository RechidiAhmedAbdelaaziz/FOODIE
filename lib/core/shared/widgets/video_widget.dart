import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final VideoPlayerController controller;

  final bool showControls;
  final bool autoPlay;
  final bool loop;

  final double width;
  final double height;
  final double borderRadius;

  const VideoWidget({
    super.key,
    required this.controller,
    this.showControls = true,
    this.autoPlay = false,
    this.loop = false,
    required this.width,
    required this.height,
    this.borderRadius = 0,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  void initState() {
    widget.controller.setLooping(widget.loop);
    widget.controller.setVolume(0);

    widget.controller.initialize().then((_) {
      setState(() {
        if (widget.autoPlay) widget.controller.play();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.pause();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: widget.controller.value.size.width,
                height: widget.controller.value.size.height,
                child: VideoPlayer(widget.controller),
              ),
            ),

            if (widget.showControls)
              Center(
                child: IconButton(
                  icon: Icon(
                    widget.controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.controller.value.isPlaying
                          ? widget.controller.pause()
                          : widget.controller.play();
                    });
                  },
                ),
              ),

            // mute button
            PositionedDirectional(
              child: IconButton(
                icon: Icon(
                  widget.controller.value.volume == 0
                      ? Icons.volume_off
                      : Icons.volume_up,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    widget.controller.setVolume(
                      widget.controller.value.volume == 0 ? 100 : 0,
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
