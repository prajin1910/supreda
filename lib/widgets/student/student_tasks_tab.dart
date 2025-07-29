import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/constants.dart';

class StudentTasksTab extends StatefulWidget {
  const StudentTasksTab({Key? key}) : super(key: key);

  @override
  State<StudentTasksTab> createState() => _StudentTasksTabState();
}

class _StudentTasksTabState extends State<StudentTasksTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTasks() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      taskProvider.fetchAllTasks(authProvider.user!.id);
      taskProvider.fetchTaskStats(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stats Cards
        Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final stats = taskProvider.stats;
            if (stats == null) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Pending',
                      stats.pending.toString(),
                      Colors.blue,
                      MdiIcons.clock,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      'Ongoing',
                      stats.ongoing.toString(),
                      Colors.orange,
                      MdiIcons.play,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      'Completed',
                      stats.completed.toString(),
                      Colors.green,
                      MdiIcons.checkCircle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      'Overdue',
                      stats.overdue.toString(),
                      Colors.red,
                      MdiIcons.alertCircle,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Tab Bar
        Container(
          color: Theme.of(context).primaryColor,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
            ],
          ),
        ),

        // Tab Content
        Expanded(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              if (taskProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (taskProvider.error != null) {
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
                        'Error loading tasks',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        taskProvider.error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadTasks,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskList(taskProvider.tasks),
                  _buildTaskList(taskProvider.tasks.where((task) => task.status == Constants.taskPending).toList()),
                  _buildTaskList(taskProvider.tasks.where((task) => task.status == Constants.taskOngoing).toList()),
                  _buildTaskList(taskProvider.tasks.where((task) => task.status == Constants.taskCompleted).toList()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<dynamic> tasks) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(dynamic task) {
    final isOverdue = task.isOverdue && task.status != Constants.taskCompleted;
    final priorityColor = Helpers.getPriorityColor(task.priority);
    final statusColor = Helpers.getStatusColor(task.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isOverdue ? Border.all(color: Colors.red, width: 2) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
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
                    child: Text(
                      task.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.priority,
                      style: TextStyle(
                        color: priorityColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              if (task.description != null && task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(MdiIcons.calendar, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Start: ${Helpers.formatDateTime(task.startDateTime)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(MdiIcons.clock, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'End: ${Helpers.formatDateTime(task.endDateTime)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MdiIcons.alertCircle, size: 16, color: Colors.red),
                          const SizedBox(width: 4),
                          Text(
                            'Overdue',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (task.status == Constants.taskCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MdiIcons.checkCircle, size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            'Completed ${task.completedAt != null ? Helpers.formatDateTime(task.completedAt) : ''}',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Text(
                      Helpers.getTimeRemaining(task.endDateTime),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isOverdue ? Colors.red : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const Spacer(),
                  _buildTaskActions(task),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskActions(dynamic task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (task.status != Constants.taskCompleted) ...[
          if (task.status == Constants.taskPending)
            IconButton(
              onPressed: () => _updateTaskStatus(task.id, Constants.taskOngoing),
              icon: Icon(MdiIcons.play, color: Colors.blue),
              tooltip: 'Start Task',
            )
          else if (task.status == Constants.taskOngoing)
            IconButton(
              onPressed: () => _updateTaskStatus(task.id, Constants.taskPending),
              icon: Icon(MdiIcons.pause, color: Colors.orange),
              tooltip: 'Pause Task',
            ),
          IconButton(
            onPressed: () => _markTaskCompleted(task.id),
            icon: Icon(MdiIcons.checkCircle, color: Colors.green),
            tooltip: 'Mark as Completed',
          ),
        ] else
          IconButton(
            onPressed: () => _updateTaskStatus(task.id, Constants.taskPending),
            icon: Icon(MdiIcons.refresh, color: Colors.blue),
            tooltip: 'Reopen Task',
          ),
        IconButton(
          onPressed: () => _editTask(task),
          icon: Icon(MdiIcons.pencil, color: Colors.grey[600]),
          tooltip: 'Edit Task',
        ),
        IconButton(
          onPressed: () => _deleteTask(task.id),
          icon: Icon(MdiIcons.delete, color: Colors.red),
          tooltip: 'Delete Task',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.checkboxMarkedCircle,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Tasks Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first task to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showCreateTaskDialog,
            icon: Icon(MdiIcons.plus),
            label: const Text('Create Task'),
          ),
        ],
      ),
    );
  }

  void _updateTaskStatus(String taskId, String status) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      await taskProvider.updateTaskStatus(taskId, authProvider.user!.id, status);
      if (taskProvider.error != null) {
        Helpers.showSnackBar(context, taskProvider.error!, isError: true);
      } else {
        Helpers.showToast('Task status updated successfully!');
        _loadTasks();
      }
    }
  }

  void _markTaskCompleted(String taskId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      await taskProvider.markTaskCompleted(taskId, authProvider.user!.id);
      if (taskProvider.error != null) {
        Helpers.showSnackBar(context, taskProvider.error!, isError: true);
      } else {
        Helpers.showToast('Task marked as completed!');
        _loadTasks();
      }
    }
  }

  void _editTask(dynamic task) {
    // Show edit task dialog
    Helpers.showToast('Edit task: ${task.title}');
  }

  void _deleteTask(String taskId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      if (authProvider.user != null) {
        await taskProvider.deleteTask(taskId, authProvider.user!.id);
        if (taskProvider.error != null) {
          Helpers.showSnackBar(context, taskProvider.error!, isError: true);
        } else {
          Helpers.showToast('Task deleted successfully!');
          _loadTasks();
        }
      }
    }
  }

  void _showCreateTaskDialog() {
    // Show create task dialog
    Helpers.showToast('Create new task');
  }
}