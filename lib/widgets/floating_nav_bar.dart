import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'glass_card.dart';
import '../theme/glass_theme.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: GlassCard(
          borderRadius: 32,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          opacity: 0.12,
          borderOpacity: 0.22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: CupertinoIcons.square_list,
                activeIcon: CupertinoIcons.square_list_fill,
                label: 'Checklists',
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: CupertinoIcons.compass,
                activeIcon: CupertinoIcons.compass_fill,
                label: 'Discover',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final activeColor = GlassTheme.secondaryAccent;
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isSelected 
              ? Colors.black.withOpacity(0.04) 
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? activeColor : GlassTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? activeColor : GlassTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
                letterSpacing: -0.2,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
