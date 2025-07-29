import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/auth_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../utils/helpers.dart';

class StudentAssessmentsTab extends StatefulWidget {
  const StudentAssessmentsTab({Key? key}) : super(key: key);

  @override
  State<StudentAssessmentsTab> createState() => _StudentAssessmentsTabState();
}

class _StudentAssessmentsTabState extends State<StudentAssessmentsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAssessments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadAssessments() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      assessmentProvider.fetchStudentAssessments(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Current'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        Expanded(
          child: Consumer<AssessmentProvider>(
            builder: (context, assessmentProvider, child) {
              if (assessmentProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (assessmentProvider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.alertCircle,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading assessments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        assessmentProvider.error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAssessments,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildCurrentAssessments(assessmentProvider),
                  _buildUpcomingAssessments(assessmentProvider),
                  _buildCompletedAssessments(assessmentProvider),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentAssessments(AssessmentProvider provider) {
    final currentAssessments = provider.assessments.where((assessment) {
      final now = DateTime.now();
      final start = DateTime.parse(assessment.startTime);
      final end = DateTime.parse(assessment.endTime);
      return now.isAfter(start) && now.isBefore(end);
    }).toList();

    if (currentAssessments.isEmpty) {
      return _buildEmptyState(
        'No Current Assessments',
        'No assessments are currently active.',
        MdiIcons.clipboardText,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: currentAssessments.length,
      itemBuilder: (context, index) {
        final assessment = currentAssessments[index];
        return _buildAssessmentCard(assessment, 'current');
      },
    );
  }

  Widget _buildUpcomingAssessments(AssessmentProvider provider) {
    final upcomingAssessments = provider.assessments.where((assessment) {
      final now = DateTime.now();
      final start = DateTime.parse(assessment.startTime);
      return now.isBefore(start);
    }).toList();

    if (upcomingAssessments.isEmpty) {
      return _buildEmptyState(
        'No Upcoming Assessments',
        'No assessments are scheduled for the future.',
        MdiIcons.calendar,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcomingAssessments.length,
      itemBuilder: (context, index) {
        final assessment = upcomingAssessments[index];
        return _buildAssessmentCard(assessment, 'upcoming');
      },
    );
  }

  Widget _buildCompletedAssessments(AssessmentProvider provider) {
    final completedAssessments = provider.assessments.where((assessment) {
      final now = DateTime.now();
      final end = DateTime.parse(assessment.endTime);
      return now.isAfter(end);
    }).toList();

    if (completedAssessments.isEmpty) {
      return _buildEmptyState(
        'No Completed Assessments',
        'No assessments have been completed yet.',
        MdiIcons.checkCircle,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedAssessments.length,
      itemBuilder: (context, index) {
        final assessment = completedAssessments[index];
        return _buildAssessmentCard(assessment, 'completed');
      },
    );
  }

  Widget _buildAssessmentCard(dynamic assessment, String type) {
    final now = DateTime.now();
    final start = DateTime.parse(assessment.startTime);
    final end = DateTime.parse(assessment.endTime);

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (type == 'current') {
      statusColor = Colors.green;
      statusText = 'Ongoing';
      statusIcon = MdiIcons.play;
    } else if (type == 'upcoming') {
      statusColor = Colors.blue;
      statusText = 'Upcoming';
      statusIcon = MdiIcons.clock;
    } else {
      statusColor = Colors.grey;
      statusText = 'Completed';
      statusIcon = MdiIcons.checkCircle;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    assessment.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              assessment.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(MdiIcons.calendar, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  Helpers.formatDate(assessment.startTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(MdiIcons.clock, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${Helpers.formatTime(assessment.startTime)} - ${Helpers.formatTime(assessment.endTime)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${assessment.questions.length} questions',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (type == 'current')
                  ElevatedButton.icon(
                    onPressed: () => _startAssessment(assessment),
                    icon: Icon(MdiIcons.play, size: 16),
                    label: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  )
                else if (type == 'upcoming')
                  Text(
                    'Starts in ${Helpers.getTimeRemaining(assessment.startTime)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () => _viewResults(assessment),
                    icon: Icon(MdiIcons.chartLine, size: 16),
                    label: const Text('View Results'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _startAssessment(dynamic assessment) {
    // Navigate to assessment taking screen
    Helpers.showToast('Starting assessment: ${assessment.title}');
  }

  void _viewResults(dynamic assessment) {
    // Navigate to results screen
    Helpers.showToast('Viewing results for: ${assessment.title}');
  }
}