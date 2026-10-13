import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portal_provider.dart';
import '../../widgets/app_sidebar.dart';
import '../../widgets/app_topbar.dart';
import '../../utils/responsive.dart';
import 'dashboard/dashboard_screen.dart';
import 'training/training_screen.dart';
import 'placements/placements_screen.dart';
import 'internships/internships_screen.dart';
import 'applications/applications_screen.dart';
import 'interview_prep/interview_prep_screen.dart';
import 'notifications/notifications_screen.dart';
import 'profile/profile_screen.dart';
import 'settings/settings_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const TrainingScreen();
      case 2:
        return const PlacementsScreen();
      case 3:
        return const InternshipsScreen();
      case 4:
        return const ApplicationsScreen();
      case 5:
        return const InterviewPrepScreen();
      case 6:
        return const NotificationsScreen();
      case 7:
        return const ProfileScreen();
      case 8:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            const AppSidebar(),
            Expanded(
              child: Column(
                children: [
                  const AppTopbar(),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _getScreen(portal.selectedTabIndex),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: AppSidebar(
            onItemTapped: () => _scaffoldKey.currentState?.closeDrawer(),
          ),
        ),
        appBar: AppTopbar(
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _getScreen(portal.selectedTabIndex),
        ),
      );
    }
  }
}
