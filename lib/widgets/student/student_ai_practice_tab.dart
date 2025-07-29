import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/ai_provider.dart';
import '../../models/ai.dart';
import '../../utils/helpers.dart';

class StudentAIPracticeTab extends StatefulWidget {
  const StudentAIPracticeTab({Key? key}) : super(key: key);

  @override
  State<StudentAIPracticeTab> createState() => _StudentAIPracticeTabState();
}

class _StudentAIPracticeTabState extends State<StudentAIPracticeTab> {
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  String _selectedDifficulty = 'MEDIUM';
  int _numberOfQuestions = 5;
  int _currentQuestion = 0;
  List<int> _answers = [];
  String _currentStep = 'setup'; // setup, questions, results

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _generateAssessment() async {
    if (_formKey.currentState!.validate()) {
      final aiProvider = Provider.of<AIProvider>(context, listen: false);
      
      final request = GenerateAssessmentRequest(
        domain: _domainController.text.trim(),
        difficulty: _selectedDifficulty,
        numberOfQuestions: _numberOfQuestions,
      );

      await aiProvider.generateAssessment(request);

      if (aiProvider.error != null) {
        Helpers.showSnackBar(context, aiProvider.error!, isError: true);
      } else {
        setState(() {
          _currentStep = 'questions';
          _currentQuestion = 0;
          _answers = List.filled(_numberOfQuestions, -1);
        });
        Helpers.showToast('AI-generated assessment ready!');
      }
    }
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[_currentQuestion] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _numberOfQuestions - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _submitAssessment();
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  Future<void> _submitAssessment() async {
    final aiProvider = Provider.of<AIProvider>(context, listen: false);
    
    final request = EvaluateAnswersRequest(
      domain: _domainController.text.trim(),
      difficulty: _selectedDifficulty,
      questions: aiProvider.questions,
      answers: _answers,
    );

    await aiProvider.evaluateAnswers(request);

    if (aiProvider.error != null) {
      Helpers.showSnackBar(context, aiProvider.error!, isError: true);
    } else {
      setState(() {
        _currentStep = 'results';
      });
      Helpers.showToast('AI evaluation completed!');
    }
  }

  void _resetAssessment() {
    final aiProvider = Provider.of<AIProvider>(context, listen: false);
    aiProvider.clearQuestions();
    aiProvider.clearEvaluation();
    
    setState(() {
      _currentStep = 'setup';
      _currentQuestion = 0;
      _answers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 'questions':
        return _buildQuestionsView();
      case 'results':
        return _buildResultsView();
      default:
        return _buildSetupView();
    }
  }

  Widget _buildSetupView() {
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
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          MdiIcons.brain,
                          color: Colors.purple,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Practice Assessment',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Generate custom practice tests with AI-powered questions and evaluation',
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

          // Setup Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI-Powered Practice Test',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Domain Field
                    TextFormField(
                      controller: _domainController,
                      decoration: InputDecoration(
                        labelText: 'Domain to Practice',
                        hintText: 'e.g., JavaScript, Python, Machine Learning, Data Structures',
                        prefixIcon: Icon(MdiIcons.school),
                        helperText: 'AI will generate questions specific to this domain',
                      ),
                      validator: (value) => Helpers.validateRequired(value, 'Domain'),
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
                          child: _buildDifficultyChip('Easy', 'EASY', Colors.green),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDifficultyChip('Medium', 'MEDIUM', Colors.orange),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDifficultyChip('Hard', 'HARD', Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Number of Questions
                    Text(
                      'Number of Questions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _numberOfQuestions,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: [5, 10, 15, 20].map((count) {
                        String description;
                        switch (count) {
                          case 5:
                            description = 'Quick Practice';
                            break;
                          case 10:
                            description = 'Standard';
                            break;
                          case 15:
                            description = 'Comprehensive';
                            break;
                          case 20:
                            description = 'Full Assessment';
                            break;
                          default:
                            description = '';
                        }
                        return DropdownMenuItem(
                          value: count,
                          child: Text('$count Questions ($description)'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _numberOfQuestions = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Generate Button
                    Consumer<AIProvider>(
                      builder: (context, aiProvider, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: aiProvider.isLoading ? null : _generateAssessment,
                            icon: aiProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Icon(MdiIcons.brain),
                            label: Text(
                              aiProvider.isLoading
                                  ? 'AI is generating questions...'
                                  : 'Generate AI Practice Test',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
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
        ],
      ),
    );
  }

  Widget _buildQuestionsView() {
    return Consumer<AIProvider>(
      builder: (context, aiProvider, child) {
        if (aiProvider.questions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final question = aiProvider.questions[_currentQuestion];
        final progress = (_currentQuestion + 1) / aiProvider.questions.length;

        return Scaffold(
          appBar: AppBar(
            title: Text('Question ${_currentQuestion + 1} of ${aiProvider.questions.length}'),
            leading: IconButton(
              icon: Icon(MdiIcons.close),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Exit Assessment'),
                    content: const Text('Are you sure you want to exit? Your progress will be lost.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _resetAssessment();
                        },
                        child: const Text('Exit'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          body: Column(
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AI Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(MdiIcons.brain, size: 16, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(
                              'AI Generated Question',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Question
                      Text(
                        question.question,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Options
                      Expanded(
                        child: ListView.builder(
                          itemCount: question.options.length,
                          itemBuilder: (context, index) {
                            final isSelected = _answers[_currentQuestion] == index;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () => _selectAnswer(index),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected ? Colors.blue : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected ? Colors.blue : Colors.grey[300],
                                        ),
                                        child: Center(
                                          child: Text(
                                            String.fromCharCode(65 + index), // A, B, C, D
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          question.options[index],
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: isSelected ? Colors.blue : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Navigation Buttons
                      Row(
                        children: [
                          if (_currentQuestion > 0)
                            OutlinedButton(
                              onPressed: _previousQuestion,
                              child: const Text('Previous'),
                            ),
                          const Spacer(),
                          Consumer<AIProvider>(
                            builder: (context, aiProvider, child) {
                              final isLastQuestion = _currentQuestion == aiProvider.questions.length - 1;
                              return ElevatedButton(
                                onPressed: _answers[_currentQuestion] != -1
                                    ? (isLastQuestion ? _submitAssessment : _nextQuestion)
                                    : null,
                                child: aiProvider.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : Text(isLastQuestion ? 'Submit for AI Evaluation' : 'Next'),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultsView() {
    return Consumer<AIProvider>(
      builder: (context, aiProvider, child) {
        final evaluation = aiProvider.evaluation;
        if (evaluation == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final percentage = (evaluation.score / evaluation.totalQuestions * 100).round();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Results Summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          MdiIcons.brain,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'AI Assessment Complete!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$percentage%',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        '${evaluation.score} out of ${evaluation.totalQuestions} correct',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // AI Feedback
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(MdiIcons.brain, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'AI Feedback',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        evaluation.feedback,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        evaluation.detailedFeedback,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Strengths and Improvements
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.green.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(MdiIcons.checkCircle, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  'Strengths',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...evaluation.strengths.map((strength) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• ', style: TextStyle(color: Colors.green[700])),
                                  Expanded(
                                    child: Text(
                                      strength,
                                      style: TextStyle(color: Colors.green[700]),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      color: Colors.orange.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(MdiIcons.lightbulbOn, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  'Areas for Improvement',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...evaluation.improvements.map((improvement) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• ', style: TextStyle(color: Colors.orange[700])),
                                  Expanded(
                                    child: Text(
                                      improvement,
                                      style: TextStyle(color: Colors.orange[700]),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _resetAssessment,
                      icon: Icon(MdiIcons.refresh),
                      label: const Text('Take Another AI Test'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Wrong Answers Review
              if (evaluation.wrongAnswers.isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(MdiIcons.brain, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'AI-Powered Answer Analysis',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...evaluation.wrongAnswers.map((wrongAnswer) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                wrongAnswer.question,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(MdiIcons.close, color: Colors.red, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Your answer: ${wrongAnswer.userAnswer}',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(MdiIcons.check, color: Colors.green, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Correct: ${wrongAnswer.correctAnswer}',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(MdiIcons.brain, size: 16, color: Colors.blue),
                                        const SizedBox(width: 4),
                                        Text(
                                          'AI Explanation',
                                          style: TextStyle(
                                            color: Colors.blue[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      wrongAnswer.explanation,
                                      style: TextStyle(color: Colors.blue[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDifficultyChip(String label, String value, Color color) {
    final isSelected = _selectedDifficulty == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDifficulty = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? color : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}