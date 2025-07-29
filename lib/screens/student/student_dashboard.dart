import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/student/student_home_tab.dart';
import '../../widgets/student/student_assessments_tab.dart';
import '../../widgets/student/student_tasks_tab.dart';
import '../../widgets/student/student_ai_roadmap_tab.dart';
import '../../widgets/student/student_ai_practice_tab.dart';
import '../../widgets/common/chat_tab.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const StudentHomeTab(),
    const StudentAssessmentsTab(),
    const StudentTasksTab(),
    const StudentAIRoadmapTab(),
    const StudentAIPracticeTab(),
    const ChatTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartEval Student'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(MdiIcons.account),
                    const SizedBox(width: 8),
                    Text(user?.username ?? 'User'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(MdiIcons.logout, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.clipboardText),
            label: 'Assessments',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.checkboxMarkedCircle),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.roadVariant),
            label: 'AI Roadmap',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.brain),
            label: 'AI Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}