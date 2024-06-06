import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionController extends GetxController {
  var offerings = Rxn<Offerings>();
  var isSubscribed = false.obs;

  final List<String> prices = ['₹100', '₹500', '₹3000'];

  @override
  void onInit() {
    super.onInit();
    fetchOfferings();
    restorePurchasesAndCheckSubscriptionStatus();
  }

  Future<void> fetchOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      this.offerings.value = offerings;
    } on PlatformException {
      // Handle error fetching offerings
    }
  }

  Future<void> restorePurchasesAndCheckSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      isSubscribed.value = customerInfo.entitlements.active.isNotEmpty;

      // if (isSubscribed.value) {
      //   Get.snackbar("Success",
      //       "Your purchases have been restored and you are subscribed.");
      // } else {
      //   Get.snackbar("Info", "No active subscriptions found.");
      // }
    } on PlatformException {
      // Handle error restoring purchases
      Get.snackbar("Error", "Failed to restore purchases.");
    }
  }

  Future<void> purchasePackage(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      isSubscribed.value = customerInfo.entitlements.active.isNotEmpty;
      Get.snackbar("😍", "Purchased Successfully.");
    } on PlatformException {
      // Handle error during purchase
      Get.snackbar("Error", "Failed to purchase.");
    }
  }
}

class SubscriptionPage extends StatelessWidget {
  final SubscriptionController controller = Get.put(SubscriptionController());

  SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color tertiaryColor = Theme.of(context).colorScheme.tertiary;
    return Scaffold(
      appBar: null,
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (controller.offerings.value == null) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 84,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  textAlign: TextAlign.start,
                  'Get',
                  style: GoogleFonts.openSans(
                    color: primaryColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  textAlign: TextAlign.start,
                  'Aura Premium',
                  style: GoogleFonts.openSans(
                    color: primaryColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  textAlign: TextAlign.start,
                  '✔️ Get Ad-Free access to Aura \n✔️ Access to Premium Playlists\n✔️ Access all Composers Ad-Free\n✔️ Listen Lofi Live Ad-Free \n✔️ Unlock All Sounds',
                  style: GoogleFonts.kanit(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16.0),
                  children: [
                    if (controller.offerings.value?.current != null)
                      ...controller.offerings.value!.current!.availablePackages
                          .map(
                            (package) => Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: tertiaryColor,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                title: Text(
                                  package.storeProduct.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: primaryColor),
                                ),
                                subtitle: Text(
                                  package.storeProduct.description,
                                  style: TextStyle(
                                      fontSize: 14.0, color: primaryColor),
                                ),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _getCustomPrice(package),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      package.storeProduct.priceString,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: primaryColor),
                                    ),
                                  ],
                                ),
                                onTap: () =>
                                    controller.purchasePackage(package),
                              ),
                            ),
                          )
                          .toList(),
                    if (controller.isSubscribed.value)
                      const Card(
                        color: Colors.lime,
                        elevation: 4.0,
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          title: Text(
                            "You are subscribed",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                      ),
                    if (!controller.isSubscribed.value)
                      ElevatedButton(
                        onPressed: () {
                          if (controller.offerings.value?.current != null &&
                              controller.offerings.value!.current!
                                  .availablePackages.isEmpty) {
                            // Show alert if no purchases found
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("No Purchases Found"),
                                  content: const Text(
                                      "You haven't made any purchases yet."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Restore purchases
                            controller
                                .restorePurchasesAndCheckSubscriptionStatus();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 32.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          "Restore Purchases",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                      height: 50,
                      child: Text(
                        'May be later',
                        style: GoogleFonts.kanit(
                          color: primaryColor,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  String _getCustomPrice(Package package) {
    int index =
        controller.offerings.value!.current!.availablePackages.indexOf(package);
    if (index != -1 && index < controller.prices.length) {
      return controller.prices[index];
    }
    return 'Price not available';
  }
}
