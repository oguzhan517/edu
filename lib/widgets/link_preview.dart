import 'package:flutter/material.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreview extends StatelessWidget {
  const LinkPreview({
    super.key,
    required this.singleMessageLink,
  });

  final String singleMessageLink;

  @override
  Widget build(BuildContext context) {
    return AnyLinkPreview(
      link: singleMessageLink,
      displayDirection: UIDirection.uiDirectionHorizontal,
      bodyMaxLines: 5,
      bodyTextOverflow: TextOverflow.ellipsis,
      titleStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      errorWidget: Container(
        color: Colors.grey[300],
        child: const Text('Link önizlemesi yüklenemedi'),
      ),
      backgroundColor: Colors.grey[300],
      borderRadius: 12,
      removeElevation: false,
      boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
      onTap: () async {
        final url = Uri.parse(singleMessageLink);
        await launchUrl(url);
      }, // This disables tap event
    );
  }
}
