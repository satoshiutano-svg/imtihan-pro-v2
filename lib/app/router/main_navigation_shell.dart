import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/imtihan_bottom_nav.dart';
import '../../core/widgets/imtihan_scaffold.dart';

/// Persistent five-tab navigation shell (Home, Learn, Papers, Practice, Progress).
///
/// Ensures Android system back navigation returns from secondary tabs to Home
/// before allowing app exit.
class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final int currentIndex = navigationShell.currentIndex;

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && currentIndex != 0) {
          navigationShell.goBranch(0);
        }
      },
      child: ImtihanScaffold(
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: ImtihanBottomNav(
          currentIndex: currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == currentIndex,
            );
          },
        ),
      ),
    );
  }
}
