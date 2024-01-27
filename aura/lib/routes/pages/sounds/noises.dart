import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class NoisesPage extends StatefulWidget {
  const NoisesPage({super.key});

  @override
  State<NoisesPage> createState() => _NoisesPageState();
}

class _NoisesPageState extends State<NoisesPage> {
  List<String> noisesImage = [
    'assets/noise/white.jpg',
    'assets/noise/pink.jpg',
    'assets/noise/brown.jpg',
    'assets/noise/blue.jpg',
    'assets/noise/violet.jpg',
    'assets/noise/grey.jpg',
    'assets/noise/red.jpg',
    'assets/noise/green.jpg',
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
                          image: AssetImage(noisesImage[index]),
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
