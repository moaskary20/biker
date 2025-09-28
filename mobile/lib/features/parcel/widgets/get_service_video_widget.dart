import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class GetServiceVideoWidget extends StatefulWidget {
  final String youtubeVideoUrl;
  final String fileVideoUrl;
  const GetServiceVideoWidget({super.key, required this.youtubeVideoUrl, required this.fileVideoUrl});

  @override
  State<GetServiceVideoWidget> createState() => _GetServiceVideoWidgetState();
}

class _GetServiceVideoWidgetState extends State<GetServiceVideoWidget> {

  late YoutubePlayerController _controller;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    
    String url = widget.youtubeVideoUrl;
    if(url.isNotEmpty && url != 'null') {
      try {
        _controller = YoutubePlayerController(params: const YoutubePlayerParams(
          showControls: true,
          mute: false,
          loop: false,
          enableCaption: false, showVideoAnnotations: false, showFullscreenButton: false,
        ));

        _controller.loadVideo(url);

        String? convertedUrl = YoutubePlayerController.convertUrlToId(url);
        if (convertedUrl != null) {
          _controller = YoutubePlayerController.fromVideoId(
            videoId: convertedUrl,
            autoPlay: false,
          );
        }
      } catch (e) {
        print('YouTube video initialization error: $e');
      }
    } else if(widget.fileVideoUrl.isNotEmpty && widget.fileVideoUrl != 'null'){
      configureForMp4(widget.fileVideoUrl);
    }
  }

  configureForMp4(String videoUrl) {
    if (videoUrl.isEmpty || videoUrl == 'null' || videoUrl == '') {
      return; // Don't initialize video player if URL is empty or null
    }
    
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        }).catchError((error) {
          print('Video initialization error: $error');
          setState(() {});
        });
      _videoPlayerController.play();
      _videoPlayerController.setVolume(0);
      Future.delayed(const Duration(seconds: 2), () {
        _videoPlayerController.pause();
        _videoPlayerController.setVolume(1);
        setState(() {});
      });
    } catch (e) {
      print('Video player error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _videoPlayerController.dispose();
    } catch (e) {
      print('Video player dispose error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.youtubeVideoUrl.isNotEmpty && widget.youtubeVideoUrl != 'null' ? ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      child: YoutubePlayer(
        controller: _controller,
        backgroundColor: Colors.transparent,
      ),
    ) : widget.fileVideoUrl.isNotEmpty && widget.fileVideoUrl != 'null' ? Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: _videoPlayerController.value.isInitialized ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          ) : const SizedBox(),
        ),

        _videoPlayerController.value.isInitialized ? Positioned(
          bottom: 10, left: 20,
          child: InkWell(
            onTap: (){
              setState(() {
                _videoPlayerController.value.isPlaying
                    ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
              });
            },
            child: Icon(
              _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 34,
            ),
          ),
        ) : const SizedBox(),
      ],
    ) : const SizedBox(); // Return empty widget if no video URL
  }
}