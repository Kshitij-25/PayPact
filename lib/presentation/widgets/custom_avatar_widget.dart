import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class CustomAvatarWidget extends StatelessWidget {
  const CustomAvatarWidget({
    super.key,
    required this.photoURL,
    required this.height,
    required this.width,
  });

  final dynamic photoURL;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color shadowColor = isDarkMode ? Colors.black54 : Color(0xFFF9FAFF);
    Color lightShadow = isDarkMode ? Colors.black38 : Color(0xFFA6AABC);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            photoURL ?? '',
            cacheKey: photoURL ?? '',
            maxHeight: 100,
            maxWidth: 100,
          ),
          fit: BoxFit.fitHeight,
          filterQuality: FilterQuality.high,
        ),
        boxShadow: [
          BoxShadow(
            color: lightShadow,
            offset: Offset(2.5, 2.5),
            blurRadius: 5,
            inset: false,
          ),
          BoxShadow(
            color: shadowColor,
            offset: Offset(-2.5, -2.5),
            blurRadius: 5,
            inset: false,
          ),
        ],
      ),
    );
  }
}
