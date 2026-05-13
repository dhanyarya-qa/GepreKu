import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
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
  bool _modelLoadError = false;

  @override
  Widget build(BuildContext context) {
    if (_modelLoadError) {
      return _buildFallbackImage();
    }

    return ModelViewer(
      src: widget.modelUrl,
      alt: 'Product 3D Model',
      ar: false,
      autoRotate: true,
      cameraControls: true,
      disableZoom: false,
      backgroundColor: Colors.transparent,
      loading: Loading.eager,
      onWebViewCreated: (controller) {
        // Model viewer created
      },
      onError: (error) {
        setState(() {
          _modelLoadError = true;
        });
      },
    );
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
