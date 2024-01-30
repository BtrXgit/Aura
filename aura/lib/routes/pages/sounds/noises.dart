import 'package:flutter/material.dart';
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
