import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/therapy/therapy_screen.dart';
import '../screens/academic/academic_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/ai_chatbot.dart';

// Custom NotchedShape for smooth concave curve
class CradleNotchedShape extends NotchedShape {
  const CradleNotchedShape();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRRect(RRect.fromRectAndRadius(host, const Radius.circular(24)));
    }

    // Semicircular cradle calculations
    final double fabRadius = guest.width / 2.0;
    final double cradleRadius = fabRadius + 6.0; // Cradle radius slightly larger than FAB
    final double cradleWidth = cradleRadius * 2.0; // Width of the semicircular cutout
    
    return Path()
      // Top-left rounded corner
      ..moveTo(host.left, host.top + 24)
      ..quadraticBezierTo(host.left, host.top, host.left + 24, host.top)
      
      // Left side leading to semicircular cradle
      ..lineTo(guest.center.dx - cradleWidth / 2, host.top)
      
      // Create perfect semicircular inward curve
      ..arcToPoint(
        Offset(guest.center.dx + cradleWidth / 2, host.top),
        radius: Radius.circular(cradleWidth / 2),
        clockwise: false, // This creates an inward semicircle
      )
      
      // Right side from cradle
      ..lineTo(host.right - 24, host.top)
      
      // Top-right rounded corner
      ..quadraticBezierTo(host.right, host.top, host.right, host.top + 24)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const TherapyScreen(),
    const AcademicScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, -1), // Upward shadow
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 0), // Additional subtle shadow
            ),
          ],
        ),
        child: BottomAppBar(
          color: const Color(0xFFFFFFFF), // Pure white
          elevation: 0, // Remove default elevation to prevent shadow conflict
          shadowColor: Colors.transparent, // Make shadow transparent
          shape: const CradleNotchedShape(),
          notchMargin: 4.0, // Reduced margin for tighter embedding
          height: 70, // Reduced height to minimize white space
          padding: EdgeInsets.zero, // Remove default padding
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 0.0), // Removed bottom padding
            child: Row(
              children: [
                // Left side navigation items
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(context, Icons.home_rounded, 0),
                      _buildNavItem(context, Icons.psychology_rounded, 1),
                    ],
                  ),
                ),
                // Space for FAB
                const SizedBox(width: 80),
                // Right side navigation items
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(context, Icons.school_rounded, 2),
                      _buildNavItem(context, Icons.person_rounded, 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const ChatbotModal(),
            );
          },
          backgroundColor: const Color(0xFF4A3427), // Your existing brown color
          elevation: 0, // Remove default elevation since we have custom shadow
          shape: const CircleBorder(), // Explicitly set circular shape
          child: const Icon(
            Icons.chat_bubble_rounded,
            color: Color(0xFFFEFEFE), // Your existing white color
            size: 24,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1), // Further reduced vertical padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32, // Increased icon size from 26 to 32
              color: isSelected 
                ? const Color(0xFF4A3427) // Your existing brown color
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 2),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                  ? const Color(0xFF4A3427) // Your existing brown color
                  : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
