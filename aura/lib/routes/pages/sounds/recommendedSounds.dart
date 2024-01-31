import 'package:aura/util/players/soundsPlayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class RecommendedSoundsPage extends StatefulWidget {
  const RecommendedSoundsPage({super.key});

  @override
  State<RecommendedSoundsPage> createState() => _RecommendedSoundsPageState();
}

class _RecommendedSoundsPageState extends State<RecommendedSoundsPage> {
  List<String> recommendedImageUrl = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Focean.jpg?alt=media&token=687073b1-be9f-4bf0-9f9f-379b60a59969',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbirdsong.jpg?alt=media&token=3273f108-27d8-4ad1-b96b-ddc845fe8407',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fpiano.jpg?alt=media&token=72789b21-67b9-4f7c-a444-d19628e54489',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fharp.jpg?alt=media&token=86b8d014-0547-404d-af58-90f9c156f4bf',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbonfire.jpg?alt=media&token=1a19e51f-260f-41b8-8e91-47afbf2572f9',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fchimes.jpg?alt=media&token=a43f462d-0e40-4be5-8fbb-55397cca4d84',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fwindintrees.jpg?alt=media&token=49c081bf-b63f-4994-92bb-eeb56cdb93d0',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fzen.jpg?alt=media&token=3d71080b-bca6-4cd2-8830-f866f4e95867',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Frainfall.jpg?alt=media&token=de69900f-6f3f-4dc5-a99b-4f4d345db517',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fthunderstorm.jpg?alt=media&token=92f285f5-3e1b-4981-bbd2-d21f4789b33f',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbowl.jpg?alt=media&token=c690e04e-e5a1-41d9-b38a-6a2c53a9d5ba',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fcity%20rain.jpg?alt=media&token=fe70dac2-953a-479e-93af-04276c1ec624',
  ];

  List<String> recommendedSoundes = [
    'Ocean Waves',
    'Birdsong',
    'Soft Piano',
    'Harp',
    'Bonfire',
    'Wind Chimes',
    'Wind in the Trees',
    'Zen Garden',
    'Rainfall',
    'Thunderstorm',
    'Tibetan Bowl',
    'City Rain',
  ];

  List<String> songs = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FOcean%20Waves.mp3?alt=media&token=50e60efc-4d61-42f0-af36-ad9ba1be46ca',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FBirdsong.mp3?alt=media&token=b589b721-3f73-4151-9b5b-ea8011a9f175',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FSoft%20Piano.mp3?alt=media&token=b99e81a3-2f90-4dbb-9111-5df0d4b54143',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FHarp.mp3?alt=media&token=74d14dfa-6255-469b-836b-613d17a4b622',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FBonfire.mp3?alt=media&token=1f50ef65-565d-4b20-bb29-8a2a2ef8f8a1',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FWind%20Chimes.mp3?alt=media&token=8fe38f34-4875-49dc-a4c0-c2cc695df620',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FWind%20in%20the%20Trees.mp3?alt=media&token=0d47a620-019d-4ab8-989f-c9718ed83261',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FZen%20Garden%20Music.mp3?alt=media&token=fd4f17fa-b0d0-4795-9cba-5e9fdd2a7c41',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FRainfall.mp3?alt=media&token=b09c640b-02dd-4b27-9b8b-54bfaf559602',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FThunderstorm.mp3?alt=media&token=a822aac1-0850-40cd-af10-2bfcb740411b',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FTibetan%20Bowl.mp3?alt=media&token=440c2ff1-ec62-4507-a759-e83e9e20793e',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FCity%20Rain.mp3?alt=media&token=84af8900-faa1-4ca4-931b-81499127a47c',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF131321),
        title: Text(
          'Recommended Sounds',
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
        itemCount: recommendedSoundes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.8,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Get.to(SoundsPlayer(
              currentIndex: index,
              songs: songs,
              title: 'Recommended Sounds',
              imageUrl: recommendedImageUrl,
              soundNames: recommendedSoundes,
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
                            image: CachedNetworkImageProvider(
                                recommendedImageUrl[index]),
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
                            recommendedSoundes[index],
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
