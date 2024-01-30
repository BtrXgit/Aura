import 'package:aura/routes/pages/live/live.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class NoisesPage extends StatefulWidget {
  const NoisesPage({super.key});

  @override
  State<NoisesPage> createState() => _NoisesPageState();
}

class _NoisesPageState extends State<NoisesPage> {
  List<String> noisesImage = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fwhite.jpg?alt=media&token=9af3e878-629c-43b4-af8f-487c3b1f14d0',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fpink.jpg?alt=media&token=34a50113-949c-4942-aadb-7c3236f4a55c',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fbrown.jpg?alt=media&token=4213f35a-3ee1-43cc-9275-8a68c6effc81',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fblue.jpg?alt=media&token=975c4669-2564-43c9-9cf4-2013dd1847a5',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fviolet.jpg?alt=media&token=60ce2298-c146-4d3a-ad68-f545f764d5e5',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fgrey.jpg?alt=media&token=6a08ebfb-3da7-49e6-a38f-3670238e2c0f',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fred.jpg?alt=media&token=bd7506c8-6f6d-4cf8-8104-bd146696cf47',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fgreen.jpg?alt=media&token=838a8722-d785-4a0b-a8e8-de171a351096',
  ];

  List<String> noisesSounds = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FWhite%20Noise.mp3?alt=media&token=bd7af2e8-2162-40c7-b0bd-e3c4ec9478e1',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FPink%20Noise.mp3?alt=media&token=4dc54875-28c0-4536-8128-450cc89679f2',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FBrown%20Noise.mp3?alt=media&token=3177c986-7c1a-4a6f-af88-9fec8ff1dd73',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FBlue%20Noise.mp3?alt=media&token=84a1d86a-9e8d-4eeb-b0a6-98c3b6b96d39',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FViolet%20Noise.mp3?alt=media&token=6dbb5547-2688-4eaa-80f7-6b24df2cc901',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FGrey%20Noise.mp3?alt=media&token=3b472e36-31cc-453a-abef-97fd6383d247',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FRed%20Noise.mp3?alt=media&token=87d2860a-ba83-41a9-99ce-8cdf5bdb0649',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FGreen%20Noise.mp3?alt=media&token=7dc7351d-9eb2-44a0-b2d1-26c963ae678c',
  ];

  List<String> noises = [
    'White',
    'Pink',
    'Brown',
    'Blue',
    'Violet',
    'Grey',
    'Red',
    'Green',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF131321),
        title: Text(
          'Noises',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF131321),
      body: _buildPlaylistListView(),
    );
  }

  Widget _buildPlaylistListView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: noises.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.8,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Get.to(LivePage(
              currentIndex: index,
              songs: noisesSounds,
              title: 'Coloured noises',
              imageUrl: noisesImage,
              soundNames: noises,
            )),
            child: Container(
              decoration: BoxDecoration(
                  // color: const Color(0xFF1F1F36),
                  image: DecorationImage(
                      image: AssetImage('assets/style2.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                CachedNetworkImageProvider(noisesImage[index]),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            noises[index],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Icon(
                            IconlyBold.play,
                            size: 54,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
