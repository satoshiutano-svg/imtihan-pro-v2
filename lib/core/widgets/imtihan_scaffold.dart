import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Base Silver Blue (Light) / Deep Navy (Dark) gradient scaffold used across screens.
class ImtihanScaffold extends StatelessWidget {
  const ImtihanScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.useSafeArea = true,
    this.extendBody = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool useSafeArea;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;

    return Container(
      decoration: BoxDecoration(
        gradient: palette.scaffoldGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: extendBody,
        appBar: appBar,
        body: useSafeArea ? SafeArea(bottom: bottomNavigationBar == null, child: body) : body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
