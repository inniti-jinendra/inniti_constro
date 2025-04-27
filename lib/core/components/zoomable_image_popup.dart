import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableImagePopup extends StatelessWidget {
  final String imageUrl; // Image URL to display
  final bool
      isNetworkImage; // Flag to indicate if the image is from the network
  final double containerHeight; // Height of the blank_container
  final double containerWidth; // Width of the blank_container

  const ZoomableImagePopup({
    super.key,
    required this.imageUrl,
    this.isNetworkImage = true,
    this.containerHeight = 300, // Default height
    this.containerWidth = 250, // Default width
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          Colors.transparent, // Make the dialog background transparent
      child: Container(
        height: containerHeight,
        width: containerWidth,
        color: Colors.black, // Background color for the image blank_container
        child: PhotoView(
          imageProvider: isNetworkImage
              ? NetworkImage(imageUrl)
              : AssetImage(imageUrl) as ImageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
        ),
      ),
    );
  }
}
