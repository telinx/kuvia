import 'dart:ui';

import 'chewie_player.dart';
import 'cupertino_controls.dart';
// import 'material_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerWithControls extends StatelessWidget {
  PlayerWithControls({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio:
              chewieController.aspectRatio ?? _calculateAspectRatio(context),
          child: _buildPlayerWithControls(chewieController, context),
        ),
      ),
    );
  }

  Container _buildPlayerWithControls(
      ChewieController chewieController, BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          chewieController.placeholder ?? Container(),
          Center(
            child: Hero(
              tag: chewieController.videoPlayerController,
              child: AspectRatio(
                aspectRatio: chewieController.aspectRatio ??
                    _calculateAspectRatio(context),
                child: VideoPlayer(chewieController.videoPlayerController),
              ),
            ),
          ),
          chewieController.overlay ?? Container(),
          _buildControls(context, chewieController),
        ],
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    ChewieController chewieController,
  ) {
    // return chewieController.showControls
    //     ? chewieController.customControls != null
    //         ? chewieController.customControls
    //         : Theme.of(context).platform == TargetPlatform.android
    //             ? MaterialControls()
    //             : CupertinoControls(
    //                 backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
    //                 iconColor: Color.fromARGB(255, 200, 200, 200),
    //               )
    //     : Container();
    // -----------------------------此处修改------------------------------- //
    return chewieController.showControls
        ? chewieController.customControls != null
            ? chewieController.customControls
            : CupertinoControls(
                backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
                // backgroundColor: Colors.red,
                iconColor: Color.fromARGB(255, 200, 200, 200),
                placeholderImageUrl: chewieController.placeholderImageUrl,
              )
        : Container();
  }

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }
}
