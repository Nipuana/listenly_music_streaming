import 'package:flutter/material.dart';

class NavIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selectedIndex;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;
  final String? tooltip;
  final double iconSize;

  const NavIcon({
    super.key,
    required this.icon,
    required this.index,
    required this.selectedIndex,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
    this.tooltip,
    this.iconSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == selectedIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: SizedBox(
          width: 78, 
          height: double.infinity,
          child: Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
  }
