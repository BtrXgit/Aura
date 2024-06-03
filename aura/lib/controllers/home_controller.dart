import 'package:aura/authentication/services/admob_service.dart';
import 'package:aura/component/native_ad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';



class AuraHomeController extends GetxController {
  var index = 0.obs;
  var userName = ''.obs;
  var userPhotoUrl = ''.obs;

  List<String> kImages = [
    'assets/relaxingLive.jpg',
    'assets/studyLive.jpg',
    'assets/sleepingLive.jpg',
  ];

  List<String> kNames = [
    'Relaxing',
    'Focus/Study',
    'Sleep',
  ];

  List<String> recommendedImageUrl = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Focean.jpg?alt=media&token=687073b1-be9f-4bf0-9f9f-379b60a59969',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbirdsong.jpg?alt=media&token=3273f108-27d8-4ad1-b96b-ddc845fe8407',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fpiano.jpg?alt=media&token=72789b21-67b9-4f7c-a444-d19628e54489',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fharp.jpg?alt=media&token=86b8d014-0547-404d-af58-90f9c156f4bf',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbonfire.jpg?alt=media&token=1a19e51f-260f-41b8-8e91-47afbf2572f9',
  ];

  List<String> recommendedSounds = [
    'Ocean Waves',
    'Birdsong',
    'Soft Piano',
    'Harp',
    'Bonfire',
  ];

  List<String> songs = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Home%2FOcean%20Waves.mp3?alt=media&token=d72831af-8b6f-4609-a43d-0ffbcb4af1a3',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Home%2FBirdsong.mp3?alt=media&token=0aa04915-ddf4-4178-a449-c4df063f3445',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FSoft%20Piano.mp3?alt=media&token=b99e81a3-2f90-4dbb-9111-5df0d4b54143',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FHarp.mp3?alt=media&token=74d14dfa-6255-469b-836b-613d17a4b622',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FBonfire.mp3?alt=media&token=1f50ef65-565d-4b20-bb29-8a2a2ef8f8a1',
  ];

  List<String> noisesImage = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fwhite.jpg?alt=media&token=9af3e878-629c-43b4-af8f-487c3b1f14d0',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fpink.jpg?alt=media&token=34a50113-949c-4942-aadb-7c3236f4a55c',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fbrown.jpg?alt=media&token=4213f35a-3ee1-43cc-9275-8a68c6effc81',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fblue.jpg?alt=media&token=975c4669-2564-43c9-9cf4-2013dd1847a5',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fviolet.jpg?alt=media&token=60ce2298-c146-4d3a-ad68-f545f764d5e5',
  ];

  List<String> noisesSounds = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FWhite%20Noise.mp3?alt=media&token=bd7af2e8-2162-40c7-b0bd-e3c4ec9478e1',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FPink%20Noise.mp3?alt=media&token=4dc54875-28c0-4536-8128-450cc89679f2',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FBrown%20Noise.mp3?alt=media&token=3177c986-7c1a-4a6f-af88-9fec8ff1dd73',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FBlue%20Noise.mp3?alt=media&token=84a1d86a-9e8d-4eeb-b0a6-98c3b6b96d39',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FViolet%20Noise.mp3?alt=media&token=6dbb5547-2688-4eaa-80f7-6b24df2cc901',
  ];

  List<String> noises = [
    'White',
    'Pink',
    'Brown',
    'Blue',
    'Violet',
  ];

  List<String> homepageCategory = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Fcozy.jpg?alt=media&token=3269db39-02fe-4d89-a05c-506cf08f27cc',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Fsynthwave.jpg?alt=media&token=d2c50d2c-c6eb-40e4-b05b-7f88bf81af31',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Fsad.jpg?alt=media&token=37f31103-0868-402e-8bf2-2401b5ca50bb',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Fhiphop.jpg?alt=media&token=88e8441e-3ef7-4b06-b628-c37de276be6e',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchUserProfileData();
  }

  Future<void> fetchUserProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'No Name';
      userPhotoUrl.value = user.photoURL ?? '';
    }
  }

  String randomRelaxingImage(String greeting) {
    switch (greeting) {
      case 'Good Morning':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F10.jpg?alt=media&token=c5f0a5f8-45f0-4a46-8837-04d46a4ecf7b';
      case 'Good Afternoon':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F3.jpg?alt=media&token=c5598838-ea0a-4038-8b77-5a45e48abe42';
      case 'Good Evening':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F2.jpg?alt=media&token=3e0cf4f7-11ef-4ad9-9d4e-5976b013b826';
      case 'Good Night':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F6.jpg?alt=media&token=80df50a3-5b3c-4586-b876-3e2a40480170';
      default:
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F10.jpg?alt=media&token=c5f0a5f8-45f0-4a46-8837-04d46a4ecf7b';
    }
  }

  String randomFocusImage(String greeting) {
    switch (greeting) {
      case 'Good Morning':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusMorning.jpg?alt=media&token=db0b3aa1-f38e-40f7-a29d-0fcadd17e3a7';
      case 'Good Afternoon':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusAfternoon.jpg?alt=media&token=dcdf8900-886c-459e-8e15-871999669766';
      case 'Good Evening':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusEvening.jpg?alt=media&token=abcbf1d0-39be-4c53-9f37-31c4fab1b702';
      case 'Good Night':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusNight.jpg?alt=media&token=942958f4-7aee-4891-b01e-30e14a7717de';
      default:
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusNight.jpg?alt=media&token=942958f4-7aee-4891-b01e-30e14a7717de';
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
  