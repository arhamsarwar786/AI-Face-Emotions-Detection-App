import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class AudioPlayer extends StatefulWidget {
  final query;
  AudioPlayer(this.query);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer>
    with TickerProviderStateMixin {
  late AnimationController iconController;
  late AnimationController controller;
  bool isAnimated = false;
  bool showPlay = true;
  bool showPause = false;

  late Animation<double> animation;

  AssetsAudioPlayer player = AssetsAudioPlayer();
  void initState(){
    super.initState();
    iconController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    player.open(Audio('assets/audios/01.mp3'),
        autoStart: false, showNotification: true);
  }

  @override
  void dispose() {
    iconController.dispose();
    controller.dispose();
    player.dispose();
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Auto Music Genrator",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.query.toUpperCase()),
            RotationTransition(
              turns: animation,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/music.png"), fit: BoxFit.fill),),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                AnimateIcon();
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: iconController,
                size: 50,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void AnimateIcon() {
    setState(() {
      isAnimated = !isAnimated;
      if (isAnimated) {
        controller.repeat();
        iconController.forward();
        player.play();
      } else {
        controller.stop();
        iconController.reverse();
        player.pause();
      }
    });
  }

}
