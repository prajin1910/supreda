import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/ai_provider.dart';
import '../../models/ai.dart';
import '../../utils/helpers.dart';

class StudentAIRoadmapTab extends StatefulWidget {
  const StudentAIRoadmapTab({Key? key}) : super(key: key);

  @override
  State<StudentAIRoadmapTab> createState() => _StudentAIRoadmapTabState();
}

class _StudentAIRoadmapTabState extends State<StudentAIRoadmapTab> {
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  final _timeframeController = TextEditingController();
  String _selectedDifficulty = 'MEDIUM';

  @override
  void dispose() {
    _domainController.dispose();
    _timeframeController.dispose();
    super.dispose();
  }

  Future<void> _generateRoadmap() async {
    if (_formKey.currentState!.validate()) {
      final aiProvider = Provider.of<AIProvider>(context, listen: false);
      
      final request = GenerateRoadmapRequest(
        domain: _domainController.text.trim(),
        timeframe: _timeframeController.text.trim(),
        difficulty: _selectedDifficulty,
      );

      await aiProvider.generateRoadmap(request);

      if (aiProvider.error != null) {
        Helpers.showSnackBar(context, aiProvider.error!, isError: true);
      } else {
        Helpers.showToast('AI roadmap generated successfully!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          MdiIcons.brain,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Learning Roadmap',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Generate personalized learning paths with advanced AI assistance',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Section
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI-Powered Roadmap Generator',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Domain Field
                          TextFormField(
                            controller: _domainController,
                            decoration: InputDecoration(
                              labelText: 'Domain to Learn',
                              hintText: 'e.g., Full Stack Development, Data Science, Machine Learning',
                              prefixIcon: Icon(MdiIcons.school),
                              helperText: 'AI will create a comprehensive learning path for this domain',
                            ),
                            validator: (value) => Helpers.validateRequired(value, 'Domain'),
                          ),
                          const SizedBox(height: 16),

                          // Timeframe Field
                          TextFormField(
                            controller: _timeframeController,
                            decoration: InputDecoration(
                              labelText: 'Time Period',
                              hintText: 'e.g., 3 months, 6 weeks, 1 year',
                              prefixIcon: Icon(MdiIcons.calendar),
                            ),
                            validator: (value) => Helpers.validateRequired(value, 'Time Period'),
                          ),
                          const SizedBox(height: 16),

                          // Difficulty Selection
                          Text(
                            'Difficulty Level',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDifficultyChip('Easy', 'EASY', Colors.green, MdiIcons.school),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDifficultyChip('Medium', 'MEDIUM', Colors.orange, MdiIcons.target),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDifficultyChip('Hard', 'HARD', Colors.red, MdiIcons.flash),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Generate Button
                          Consumer<AIProvider>(
                            builder: (context, aiProvider, child) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: aiProvider.isLoading ? null : _generateRoadmap,
                                  icon: aiProvider.isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : Icon(MdiIcons.brain),
                                  label: Text(
                                    aiProvider.isLoading
                                        ? 'AI is creating your roadmap...'
                                        : 'Generate AI Roadmap',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Roadmap Display Section
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Consumer<AIProvider>(
                      builder: (context, aiProvider, child) {
                        if (aiProvider.roadmap.isEmpty) {
                          return _buildEmptyRoadmapState();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(MdiIcons.brain, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  'Your AI-Generated Learning Path',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI Insights',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'AI has analyzed your requirements and created a personalized learning path for ${_domainController.text} at ${_selectedDifficulty.toLowerCase()} level to be completed in ${_timeframeController.text}.',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            Expanded(
                              child: ListView.builder(
                                itemCount: aiProvider.roadmap.length,
                                itemBuilder: (context, index) {
                                  final step = aiProvider.roadmap[index];
                                  return _buildRoadmapStep(index + 1, step);
                                },
                              ),
                            ),

                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(MdiIcons.target, color: Colors.green[800]),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Completion Goal',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'This AI-generated roadmap is customized for your ${_selectedDifficulty.toLowerCase()} level and designed to help you master ${_domainController.text} within ${_timeframeController.text}.',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String label, String value, Color color, IconData icon) {
    final isSelected = _selectedDifficulty == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDifficulty = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRoadmapState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          MdiIcons.brain,
          size: 64,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          'AI Learning Path Generator',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill out the form to generate your personalized AI roadmap',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Google Gemini AI will analyze your requirements and create a customized learning path',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[400],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRoadmapStep(int stepNumber, String step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Step $stepNumber of ${Provider.of<AIProvider>(context).roadmap.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}