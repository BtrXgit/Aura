import 'package:aura/routes/pages/live/live.dart';
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
    'https://i.pinimg.com/564x/a5/ba/00/a5ba003ca05f2646b8c2735ac0b6e3d9.jpg',
    'https://i.pinimg.com/736x/7e/bb/a1/7ebba1c8f506046205f223e7f4477994.jpg',
    'https://i.pinimg.com/564x/6d/b2/d4/6db2d4c4c456211650429781a47ee95b.jpg',
    'https://i.pinimg.com/564x/75/50/0b/75500bd88c86833f3c64b769d5d197de.jpg',
    'https://i.pinimg.com/564x/b6/31/84/b631841cb3a29e6f7be99c5ec0bca1d0.jpg',
    'https://i.pinimg.com/564x/6e/21/e0/6e21e00acfcfbbb7b334486261e8e77d.jpg',
    'https://i.pinimg.com/564x/e4/22/3c/e4223c9d320ca6e36d1df970a51f698e.jpg',
    'https://i.pinimg.com/564x/01/17/27/01172784637ef7315a6273afb8cc6321.jpg',
    'https://i.pinimg.com/564x/08/d8/15/08d815e77dd4e30228615c502ae063a3.jpg',
    'https://i.pinimg.com/564x/34/00/9c/34009cf70efce641f8fcf91cc6e8b815.jpg',
    'https://i.pinimg.com/564x/f8/0e/04/f80e04732ee19168c1f5d0372ff4a460.jpg',
    'https://i.pinimg.com/564x/72/1a/9b/721a9bccca150b0e99b8fade5385e984.jpg',
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
            onTap: () => Get.to(LivePage(
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
