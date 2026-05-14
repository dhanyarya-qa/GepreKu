import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Product3DViewer extends StatefulWidget {
  final String modelUrl;
  final String fallbackImageUrl;
  
  const Product3DViewer({
    super.key,
    required this.modelUrl,
    required this.fallbackImageUrl,
  });

  @override
  State<Product3DViewer> createState() => _Product3DViewerState();
}

class _Product3DViewerState extends State<Product3DViewer> {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement 3D viewer when model_viewer_plus is added
    // For now, just show the fallback image
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return CachedNetworkImage(
      imageUrl: widget.fallbackImageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 48,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
