import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/auth_provider.dart';
import '../../providers/alumni_provider.dart';
import '../../utils/helpers.dart';

class ProfessorAlumniTab extends StatefulWidget {
  const ProfessorAlumniTab({Key? key}) : super(key: key);

  @override
  State<ProfessorAlumniTab> createState() => _ProfessorAlumniTabState();
}

class _ProfessorAlumniTabState extends State<ProfessorAlumniTab> {
  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  void _loadPendingRequests() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final alumniProvider = Provider.of<AlumniProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      alumniProvider.fetchPendingRequests(authProvider.user!.id);
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
                'Alumni Management',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Review and approve alumni registration requests',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Alumni Requests List
        Expanded(
          child: Consumer<AlumniProvider>(
            builder: (context, alumniProvider, child) {
              if (alumniProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (alumniProvider.error != null) {
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
                        'Error loading alumni requests',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alumniProvider.error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPendingRequests,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (alumniProvider.requests.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: alumniProvider.requests.length,
                itemBuilder: (context, index) {
                  final request = alumniProvider.requests[index];
                  return _buildAlumniRequestCard(request);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAlumniRequestCard(dynamic request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    Helpers.getInitials(request.alumniUsername),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.alumniUsername,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(MdiIcons.email, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            request.alumniEmail,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Pending',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alumni Registration Request',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Wants to join as Alumni and connect with current students',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(MdiIcons.clock, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Requested on ${Helpers.formatDate(request.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _approveRequest(request.id),
                      icon: Icon(MdiIcons.check, size: 16),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _rejectRequest(request.id),
                      icon: Icon(MdiIcons.close, size: 16),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
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
            MdiIcons.accountGroup,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No pending requests',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All alumni requests have been processed',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _approveRequest(String requestId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Alumni Request'),
        content: const Text('Are you sure you want to approve this alumni registration request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final alumniProvider = Provider.of<AlumniProvider>(context, listen: false);
      await alumniProvider.approveRequest(requestId);
      
      if (alumniProvider.error != null) {
        Helpers.showSnackBar(context, alumniProvider.error!, isError: true);
      } else {
        Helpers.showToast('Alumni request approved successfully!');
        _loadPendingRequests();
      }
    }
  }

  void _rejectRequest(String requestId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Alumni Request'),
        content: const Text('Are you sure you want to reject this alumni registration request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final alumniProvider = Provider.of<AlumniProvider>(context, listen: false);
      await alumniProvider.rejectRequest(requestId);
      
      if (alumniProvider.error != null) {
        Helpers.showSnackBar(context, alumniProvider.error!, isError: true);
      } else {
        Helpers.showToast('Alumni request rejected');
        _loadPendingRequests();
      }
    }
  }
}