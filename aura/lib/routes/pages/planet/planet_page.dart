import 'dart:ui';
import 'package:aura/component/planet_widgets.dart';
import 'package:flutter/material.dart';

class PlanetPage extends StatefulWidget {
  const PlanetPage({Key? key}) : super(key: key);

  @override
  State<PlanetPage> createState() => _PlanetPageState();
}

class _PlanetPageState extends State<PlanetPage> {
  bool isInteracting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildGradientOverlay(),
          Center(
            child: _buildPlanet(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.network(
        'https://i.pinimg.com/736x/ac/be/49/acbe49c3f106d163937b8c05c4d48b05.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Opacity(
      opacity: 0.5,
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              const Color.fromARGB(255, 49, 88, 116),
              const Color.fromARGB(255, 4, 11, 34),
            ],
            radius: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanet() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isInteracting = !isInteracting;
        });
      },
      child: Planet(
        key: isInteracting ? Key('Planet2') : Key('Planet1'),
        interative: isInteracting,
      ),
    );
  }
}
