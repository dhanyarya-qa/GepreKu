import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_theme.dart';
import '../../../domain/entities/service_request.dart';
import '../../../data/providers/service_request_provider.dart';

class DigitalBellButton extends ConsumerStatefulWidget {
  const DigitalBellButton({super.key});

  @override
  ConsumerState<DigitalBellButton> createState() => _DigitalBellButtonState();
}

class _DigitalBellButtonState extends ConsumerState<DigitalBellButton>
    with SingleTickerProviderStateMixin {
  bool _isOnCooldown = false;
  int _cooldownSeconds = 0;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    setState(() {
      _isOnCooldown = true;
      _cooldownSeconds = 30;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      
      setState(() {
        _cooldownSeconds--;
      });

      if (_cooldownSeconds <= 0) {
        setState(() {
          _isOnCooldown = false;
        });
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isOnCooldown ? 1.0 : 1.0 + (_pulseController.value * 0.1),
          child: FloatingActionButton.extended(
            onPressed: _isOnCooldown ? null : () => _showServiceDialog(context),
            backgroundColor: _isOnCooldown
                ? Colors.grey
                : AppTheme.primaryRed,
            icon: Icon(
              _isOnCooldown ? Icons.timer : Icons.notifications_active,
              color: Colors.white,
            ),
            label: Text(
              _isOnCooldown ? '$_cooldownSeconds s' : 'Call Waiter',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showServiceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ServiceRequestDialog(
        onRequestSent: () {
          _startCooldown();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permintaan terkirim! Pelayan akan segera datang.'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

class ServiceRequestDialog extends ConsumerWidget {
  final VoidCallback onRequestSent;
  
  const ServiceRequestDialog({
    super.key,
    required this.onRequestSent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      ServiceCategory.tisu,
      ServiceCategory.alatMakan,
      ServiceCategory.air,
      ServiceCategory.bantuanLain,
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Apa yang Anda butuhkan?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pilih kategori permintaan Anda',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ...categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCategoryButton(
                context,
                ref,
                category,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    WidgetRef ref,
    ServiceCategory category,
  ) {
    IconData icon;
    switch (category) {
      case ServiceCategory.tisu:
        icon = Icons.cleaning_services;
        break;
      case ServiceCategory.alatMakan:
        icon = Icons.restaurant;
        break;
      case ServiceCategory.air:
        icon = Icons.water_drop;
        break;
      case ServiceCategory.bantuanLain:
        icon = Icons.help_outline;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await ref.read(serviceRequestServiceProvider).createServiceRequest(
                category: category,
              );
          onRequestSent();
        },
        icon: Icon(icon),
        label: Text(category.displayName),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppTheme.primaryYellow,
          foregroundColor: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
