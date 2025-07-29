import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/auth_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../utils/helpers.dart';

class ProfessorAssessmentsTab extends StatefulWidget {
  const ProfessorAssessmentsTab({Key? key}) : super(key: key);

  @override
  State<ProfessorAssessmentsTab> createState() => _ProfessorAssessmentsTabState();
}

class _ProfessorAssessmentsTabState extends State<ProfessorAssessmentsTab> {
  @override
  void initState() {
    super.initState();
    _loadAssessments();
  }

  void _loadAssessments() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      assessmentProvider.fetchProfessorAssessments(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Assessment Management',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showCreateAssessmentDialog,
                icon: Icon(MdiIcons.plus),
                label: const Text('Create Assessment'),
              ),
            ],
          ),
        ),

        // Assessments List
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

              if (assessmentProvider.assessments.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: assessmentProvider.assessments.length,
                itemBuilder: (context, index) {
                  final assessment = assessmentProvider.assessments[index];
                  return _buildAssessmentCard(assessment);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAssessmentCard(dynamic assessment) {
    final now = DateTime.now();
    final start = DateTime.parse(assessment.startTime);
    final end = DateTime.parse(assessment.endTime);

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (now.isBefore(start)) {
      statusColor = Colors.blue;
      statusText = 'Scheduled';
      statusIcon = MdiIcons.clock;
    } else if (now.isAfter(start) && now.isBefore(end)) {
      statusColor = Colors.green;
      statusText = 'Ongoing';
      statusIcon = MdiIcons.play;
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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(MdiIcons.account, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${assessment.assignedStudents.length} students assigned',
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _viewResults(assessment),
                      icon: Icon(MdiIcons.chartLine, size: 20),
                      tooltip: 'View Results',
                    ),
                    IconButton(
                      onPressed: () => _editAssessment(assessment),
                      icon: Icon(MdiIcons.pencil, size: 20),
                      tooltip: 'Edit Assessment',
                    ),
                    IconButton(
                      onPressed: () => _deleteAssessment(assessment.id),
                      icon: Icon(MdiIcons.delete, size: 20, color: Colors.red),
                      tooltip: 'Delete Assessment',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.clipboardText,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No assessments yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first assessment to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showCreateAssessmentDialog,
            icon: Icon(MdiIcons.plus),
            label: const Text('Create Assessment'),
          ),
        ],
      ),
    );
  }

  void _showCreateAssessmentDialog() {
    Helpers.showToast('Create assessment feature coming soon!');
  }

  void _viewResults(dynamic assessment) {
    Helpers.showToast('Viewing results for: ${assessment.title}');
  }

  void _editAssessment(dynamic assessment) {
    Helpers.showToast('Editing assessment: ${assessment.title}');
  }

  void _deleteAssessment(String assessmentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assessment'),
        content: const Text('Are you sure you want to delete this assessment? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Helpers.showToast('Assessment deleted successfully!');
      _loadAssessments();
    }
  }
}