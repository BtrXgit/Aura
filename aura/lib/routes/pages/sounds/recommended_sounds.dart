import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
          return Container(
            decoration: BoxDecoration(
                // color: const Color(0xFF1F1F36),
                image: DecorationImage(
                    image: AssetImage('assets/style2.png'), fit: BoxFit.cover),
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
          );
        },
      ),
    );
  }
}
