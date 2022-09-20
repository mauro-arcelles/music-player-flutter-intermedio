import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/helpers/helpers.dart';
import 'package:music_player/models/audioplayer_model.dart';
import 'package:music_player/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          Column(
            children: const [
              CustomAppBar(),
              _ImagenDiscoDuracion(),
              _TituloPlay(),
              SizedBox(height: 20),
              Expanded(child: _Lyrics()),
            ],
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ],
        ),
      ),
    );
  }
}

class _Lyrics extends StatelessWidget {
  const _Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();

    return Container(
      child: ListWheelScrollView(
        physics: const BouncingScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 1.5,
        children: lyrics
            .map(
              (e) => Text(e, style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.6))),
            )
            .toList(),
      ),
    );
  }
}

class _TituloPlay extends StatefulWidget {
  const _TituloPlay({
    Key? key,
  }) : super(key: key);

  @override
  State<_TituloPlay> createState() => _TituloPlayState();
}

class _TituloPlayState extends State<_TituloPlay> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController controller;

  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
    assetAudioPlayer.open(
      Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
      autoStart: true,
      showNotification: true,
    );

    assetAudioPlayer.currentPosition.listen((event) {
      audioPlayerModel.current = event;
    });

    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration = playingAudio?.audio.duration ?? const Duration(milliseconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      margin: const EdgeInsets.only(top: 30),
      child: Row(
        children: [
          Column(
            children: [
              Text('Far Away', style: TextStyle(fontSize: 30, color: Colors.white.withOpacity(0.8))),
              Text(
                '- Breaking Benjamin -',
                style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

              if (isPlaying) {
                controller.reverse();
                isPlaying = false;
                audioPlayerModel.controller.stop();
              } else {
                controller.forward();
                isPlaying = true;
                audioPlayerModel.controller.repeat();
              }

              if (firstTime) {
                open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
            backgroundColor: const Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: controller,
            ),
          )
        ],
      ),
    );
  }
}

class _ImagenDiscoDuracion extends StatelessWidget {
  const _ImagenDiscoDuracion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 70),
      child: Row(
        children: const [
          _ImagenDisco(),
          Spacer(),
          Expanded(child: _BarraProgreso()),
        ],
      ),
    );
  }
}

class _BarraProgreso extends StatelessWidget {
  const _BarraProgreso({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      child: Column(
        children: [
          Text(audioPlayerModel.songTotalDuration, style: TextStyle(color: Colors.white.withOpacity(0.4))),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: 3,
                height: 230,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 230 * audioPlayerModel.porcentaje,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(audioPlayerModel.currentSecond, style: TextStyle(color: Colors.white.withOpacity(0.4))),
        ],
      ),
    );
  }
}

class _ImagenDisco extends StatelessWidget {
  const _ImagenDisco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1e1c24),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: const Duration(seconds: 10),
              animate: false,
              infinite: true,
              manualTrigger: true,
              controller: (animationcontroller) => audioPlayerModel.controller = animationcontroller,
              child: const Image(image: AssetImage('assets/aurora.jpg')),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xff1c1c25),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
