import 'package:flutter/material.dart';
import 'package:music_player/models/audioplayer_model.dart';
import 'package:music_player/screens/music_player_screen.dart';
import 'package:music_player/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioPlayerModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: miTema,
        title: 'Material App',
        home: const Scaffold(
          body: MusicPlayerScreen(),
        ),
      ),
    );
  }
}
