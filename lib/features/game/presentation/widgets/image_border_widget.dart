import 'package:flutter/cupertino.dart';

/// A widget that displays an image border.
class ImageBorderWidget extends StatelessWidget {
  /// Creates a [ImageBorderWidget] instance.
  const ImageBorderWidget({
    required this.image,
    required this.size,
    super.key,
  });

  /// The image to be displayed.
  final ImageProvider<Object> image;

  /// The size of the widget.
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
      width: size.width,
      height: size.height,
    );
  }
}
