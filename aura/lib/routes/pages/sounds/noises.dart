import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class NoisesPage extends StatefulWidget {
  const NoisesPage({super.key});

  @override
  State<NoisesPage> createState() => _NoisesPageState();
}

class _NoisesPageState extends State<NoisesPage> {
  List<String> noisesImageUrl = [
    'https://i.pinimg.com/564x/85/fb/ce/85fbceb25101eb2e3fba7a7ffcb20bae.jpg',
    'https://blog.noisli.com/wp-content/uploads/2022/08/Noisli-Pink-Noise.png',
    'https://i.kym-cdn.com/entries/icons/facebook/000/040/983/bnoise.jpg',
    'https://images.genius.com/3e8640695c1f56148f30626ac1007a67.1000x1000x1.png',
    'https://i.scdn.co/image/ab67616d0000b273f98f724102403c1e69958c8c',
    'https://live.staticflickr.com/43/84967293_6e4c727e4d_b.jpg',
    'https://png.pngtree.com/thumb_back/fh260/background/20231108/pngtree-high-definition-texture-background-with-red-blank-vhs-picture-noise-image_13801828.png',
    'https://i.scdn.co/image/ab67616d0000b273cc08b98a36dd7d3b924270a0',
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
        itemCount: noises.length,
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
                          image:
                              CachedNetworkImageProvider(noisesImageUrl[index]),
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
          );
        },
      ),
    );
  }
}
