import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';
import 'package:fitkle/shared/widgets/buttons/app_icon_button.dart';

class EventHeaderImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onBackPressed;

  const EventHeaderImage({
    super.key,
    required this.imageUrl,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 272,
      pinned: false,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            _buildGradientOverlay(),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder();
            },
          )
        : _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.primary.withValues(alpha: 0.1),
      child: const Icon(Icons.image, size: 64),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: AppIconButton(
          icon: Icons.arrow_back,
          color: Colors.white,
          size: 24,
          onPressed: onBackPressed,
        ),
      ),
    );
  }
}
