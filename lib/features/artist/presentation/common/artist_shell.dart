import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/features/artist/presentation/common/artist_drawer.dart';

class ArtistShell extends StatelessWidget {
  final String currentRoute;
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const ArtistShell({
    super.key,
    required this.currentRoute,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final showSidebar = width >= 1024;

    if (!showSidebar) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          elevation: 0,
          actions: actions,
        ),
        drawer: ArtistDrawer(currentRoute: currentRoute),
        body: body,
        floatingActionButton: floatingActionButton,
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          SizedBox(
            width: 288,
            child: Material(
              elevation: 8,
              child: ArtistNavigationPanel(
                currentRoute: currentRoute,
                compact: true,
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 76,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      border: Border(
                        bottom: BorderSide(
                          color: theme.dividerColor.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (actions != null) ...actions!,
                      ],
                    ),
                  ),
                  Expanded(child: body),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}