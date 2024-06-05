import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';

class GetAndUpload extends StatefulWidget {
  @override
  _GetAndUploadState createState() => _GetAndUploadState();
}

class _GetAndUploadState extends State<GetAndUpload> {
  bool isLoading = false;

  Future<List<Map<String, String>>> fetchSongsAndImages() async {
    List<Map<String, String>> data = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      // Fetch song references
      ListResult songResult =
          await storage.ref('Playlists/Sleep LoFi').listAll();
      // Fetch image references
      ListResult imageResult =
          await storage.ref('Playlists/Cover Art/Sleep').listAll();

      // Log the fetched references
      print('Fetched ${songResult.items.length} songs');
      print('Fetched ${imageResult.items.length} images');

      // Fetch download URLs for songs
      List<String> songUrls = await Future.wait(
        songResult.items.map((ref) => ref.getDownloadURL()).toList(),
      );

      // Fetch download URLs for images
      List<String> imageUrls = await Future.wait(
        imageResult.items.map((ref) => ref.getDownloadURL()).toList(),
      );

      // Log the URLs
      print('Song URLs: $songUrls');
      print('Image URLs: $imageUrls');

      // Check if songUrls and imageUrls are not empty
      if (songUrls.isEmpty || imageUrls.isEmpty) {
        print('No songs or images found.');
        return data;
      }

      // Randomly select artist and image for each song
      Random random = Random();
      List<String> artists = ['Lucid', 'Aura', 'Lofi Records'];

      for (Reference songRef in songResult.items) {
        String songUrl = await songRef.getDownloadURL();
        // String fileName = songUrl.split('/').last;
        String fileName = songRef.name;
        String songName = fileName.split('.').first;
        String imageUrl = imageUrls[random.nextInt(imageUrls.length)];
        String artist = artists[random.nextInt(artists.length)];

        data.add({
          'songName': songName,
          'songUrl': songUrl,
          'artist': artist,
          'imageUrl': imageUrl,
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return data;
  }

  Future<void> uploadToFirestore(List<Map<String, String>> data) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference sounds =
        firestore.collection('Liveplaylist').doc('Sleep').collection('sounds');

    int uploadedItems = 0;

    for (Map<String, String> songData in data) {
      try {
        await sounds.add({
          'songName': songData['songName'],
          'songUrl': songData['songUrl'],
          'artist': songData['artist'],
          'imageUrl': songData['imageUrl'],
        });
        uploadedItems++;
        print('Uploaded data: $songData');
      } catch (error) {
        print('Error uploading data: $error');
      }
    }
    print('Successfully uploaded $uploadedItems items');
  }

  Future<void> fetchAndUpload() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, String>> data = await fetchSongsAndImages();
      if (data.isNotEmpty) {
        await uploadToFirestore(data);
      } else {
        print('No data to upload');
      }
    } catch (e) {
      print('Error during fetch and upload: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase App'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: fetchAndUpload,
                child: Text('Upload Songs'),
              ),
      ),
    );
  }
}
