import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class DevotionalPage extends StatefulWidget {
  final String category;

  const DevotionalPage({super.key, required this.category});

  @override
  State<DevotionalPage> createState() => _DevotionalPageState();
}

class _DevotionalPageState extends State<DevotionalPage> {
  List<String> devotionalImageUrl = [
    'https://i.ytimg.com/vi/VUEHJLFKKP0/maxresdefault.jpg',
    'https://www.rohitghai.com/wp-content/uploads/2019/08/Gayatri-Mantra-poster.jpeg',
    'https://images.fineartamerica.com/images/artworkimages/mediumlarge/2/2-lord-krishna-vishal-gurjar.jpg',
    'https://th.bing.com/th/id/OIP.i1qj9zLRbSE1djfKhphxpwHaKR?rs=1&pid=ImgDetMain',
    'https://cdn11.bigcommerce.com/s-x49po/images/stencil/2560w/products/7546/136588/Buddha_Meditation_260322__24004.1648290309.jpg?c=2',
    'https://img.freepik.com/premium-photo/man-praying-inside-beautifully-structured-mosque_800563-173.jpg?w=826',
    'https://th.bing.com/th/id/OIP.bkZGppGOlYAK8bXPFQ00SAHaKX?w=571&h=799&rs=1&pid=ImgDetMain',
  ];
  List<String> devotionalSounds = [
    'OM Chanting',
    'Gayatri Mantra',
    'Hare Krishna Mantra',
    'Om Namah Shivay',
    'Tibetan Buddhist Chants',
    'Adhan',
    'Gurbani Kirtan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF131321),
        title: Text(
          widget.category,
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
        itemCount: devotionalSounds.length,
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
                              devotionalImageUrl[index]),
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
                          devotionalSounds[index],
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
