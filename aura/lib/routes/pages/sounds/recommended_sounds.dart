import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
  ];
  List<String> recommendedSoundes = [
    'Ocean Waves',
    'Birdsong',
    'Soft Piano',
    'Harp',
    'Bonfire',
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
                color: const Color(0xFF1F1F36),
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
                    padding: EdgeInsets.only(right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          recommendedSoundes[index],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
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
