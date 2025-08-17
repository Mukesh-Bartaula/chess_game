import 'package:chess_game/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:chess_game/screens/screens.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MyColor.mediumBlue300,
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text('Chess Game'),
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.video_call),
                title: const Text('Video call'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoCall(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic),
                title: const Text('Voice call'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VoiceCall(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                onTap: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
