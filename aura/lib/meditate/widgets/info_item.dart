import 'package:aura/meditate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class InfoItem extends StatelessWidget {
  final String type;
  final String details;
  final String url;

  const InfoItem(
      {Key? key,
      required this.type,
      required this.details,
      required this.url})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(
              color: lightGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 16.0),
          Text(
            details,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: lightGreen,
              fontSize: 18,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 12.0,
              right: 8.0,
            ),
            alignment: Alignment.centerRight,
            child: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    text: "Source",
                    style: TextStyle(
                      color: lightGreen,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.open_in_new,
                      color: lightGreen,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
