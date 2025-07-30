import React, { useState } from 'react';
import { X, Plus, Trash2 } from 'lucide-react';
import { Question } from '../../types';

interface CreateAssessmentModalProps {
  onClose: () => void;
  onSubmit: (assessment: any) => void;
}

const CreateAssessmentModal: React.FC<CreateAssessmentModalProps> = ({ onClose, onSubmit }) => {
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    startTime: '',
    endTime: '',
    assignedStudents: [] as string[],
  });
  const [questions, setQuestions] = useState<Omit<Question, 'id'>[]>([
    {
      questionText: '',
      options: ['', '', '', ''],
      correctAnswer: 0,
    }
  ]);
  const [studentInput, setStudentInput] = useState('');

  // Helper function to format date for datetime-local input
  const formatDateTimeLocal = (date: Date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`;
  };

  // Helper function to convert datetime-local input to ISO string
  const convertToISOString = (dateTimeLocal: string) => {
    if (!dateTimeLocal) return '';
    // Create date object from the local datetime string
    const date = new Date(dateTimeLocal);
    return date.toISOString();
  };
  const addQuestion = () => {
    setQuestions([...questions, {
      questionText: '',
      options: ['', '', '', ''],
      correctAnswer: 0,
    }]);
  };

  const removeQuestion = (index: number) => {
    setQuestions(questions.filter((_, i) => i !== index));
  };

  const updateQuestion = (index: number, field: string, value: any) => {
    const updated = [...questions];
    if (field === 'options') {
      updated[index] = { ...updated[index], options: value };
    } else {
      updated[index] = { ...updated[index], [field]: value };
    }
    setQuestions(updated);
  };

  const updateOption = (questionIndex: number, optionIndex: number, value: string) => {
    const updated = [...questions];
    updated[questionIndex].options[optionIndex] = value;
    setQuestions(updated);
  };

  const addStudent = () => {
    const trimmedInput = studentInput.trim();
    if (trimmedInput && !formData.assignedStudents.includes(trimmedInput)) {
      setFormData({
        ...formData,
        assignedStudents: [...formData.assignedStudents, trimmedInput]
      });
      setStudentInput('');
    } else if (formData.assignedStudents.includes(trimmedInput)) {
      alert('Student already added to the assessment');
    }
  };

  const removeStudent = (student: string) => {
    setFormData({
      ...formData,
      assignedStudents: formData.assignedStudents.filter(s => s !== student)
    });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate dates
    if (!formData.startTime || !formData.endTime) {
      alert('Please select both start and end times');
      return;
    }
    
    const startTime = new Date(formData.startTime);
    const endTime = new Date(formData.endTime);
    const now = new Date();
    
    // Allow scheduling assessments that start within the next 5 minutes for testing
    const fiveMinutesFromNow = new Date(now.getTime() + 5 * 60 * 1000);
    if (startTime < fiveMinutesFromNow) {
      alert('Start time must be at least 5 minutes in the future');
      return;
    }
    
    if (endTime <= startTime) {
      alert('End time must be after start time');
      return;
    }
    
    // Minimum duration check (at least 10 minutes)
    const durationMs = endTime.getTime() - startTime.getTime();
    const durationMinutes = durationMs / (1000 * 60);
    if (durationMinutes < 10) {
      alert('Assessment duration must be at least 10 minutes');
      return;
    }
    
    if (formData.assignedStudents.length === 0) {
      alert('Please assign at least one student');
      return;
    }
    
    if (questions.length === 0) {
      alert('Please add at least one question');
      return;
    }
    
    // Validate all questions have content and options
    for (let i = 0; i < questions.length; i++) {
      const question = questions[i];
      if (!question.questionText.trim()) {
        alert(`Question ${i + 1} is missing question text`);
        return;
      }
      
      for (let j = 0; j < question.options.length; j++) {
        if (!question.options[j].trim()) {
          alert(`Question ${i + 1}, Option ${String.fromCharCode(65 + j)} is empty`);
          return;
        }
      }
    }
    
    const assessment = {
      ...formData,
      questions: questions.map((q, index) => ({ ...q, id: `q${index}` })),
      startTime: startTime.toISOString(),
      endTime: endTime.toISOString(),
    };
    
    console.log('Creating assessment with times:', {
      startTime: assessment.startTime,
      endTime: assessment.endTime,
      localStartTime: formData.startTime,
      localEndTime: formData.endTime
    });
    
    onSubmit(assessment);
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div className="flex justify-between items-center p-6 border-b">
          <h2 className="text-2xl font-bold text-gray-900">Create New Assessment</h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6 space-y-6">
          {/* Basic Information */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Assessment Title
              </label>
              <input
                type="text"
                value={formData.title}
                onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Enter assessment title"
                required
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Description
              </label>
              <textarea
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                rows={3}
                placeholder="Enter assessment description"
                required
              />
            </div>
          </div>

          {/* Timing */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Start Date & Time
              </label>
              <input
                type="datetime-local"
                value={formData.startTime}
                onChange={(e) => setFormData({ ...formData, startTime: e.target.value })}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                step="60"
                required
              />
              <p className="text-xs text-gray-500 mt-1">
                Select the exact date and time when the assessment should start
              </p>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                End Date & Time
              </label>
              <input
                type="datetime-local"
                value={formData.endTime}
                onChange={(e) => setFormData({ ...formData, endTime: e.target.value })}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                step="60"
                required
              />
              <p className="text-xs text-gray-500 mt-1">
                Select the exact date and time when the assessment should end
              </p>
            </div>
          </div>

          {/* Duration Display */}
          {formData.startTime && formData.endTime && (
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
              <h4 className="text-sm font-medium text-blue-800 mb-2">Assessment Duration</h4>
              <div className="text-sm text-blue-700">
                <p>Start: {formData.startTime ? new Date(formData.startTime).toLocaleString() : 'Not set'}</p>
                <p>End: {formData.endTime ? new Date(formData.endTime).toLocaleString() : 'Not set'}</p>
                <p>Current Time: {new Date().toLocaleString()}</p>
                {(() => {
                  if (formData.startTime && formData.endTime) {
                    const start = new Date(formData.startTime);
                    const end = new Date(formData.endTime);
                    const diffMs = end.getTime() - start.getTime();
                    if (diffMs > 0) {
                      const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
                      const diffMinutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));
                      return (
                        <div>
                          <p className="font-medium">Duration: {diffHours}h {diffMinutes}m</p>
                          <p className="text-xs mt-1">
                            Time until start: {Math.max(0, Math.floor((start.getTime() - new Date().getTime()) / (1000 * 60)))} minutes
                          </p>
                        </div>
                      );
                    }
                  }
                  return null;
                })()}
              </div>
            </div>
          )}

          {/* Student Assignment */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Assign to Students
            </label>
            <div className="flex space-x-2 mb-3">
              <input
                type="text"
                value={studentInput}
                onChange={(e) => setStudentInput(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && (e.preventDefault(), addStudent())}
                className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Enter student email address"
              />
              <button
                type="button"
                onClick={addStudent}
                className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
              >
                Add
              </button>
            </div>
            
            {formData.assignedStudents.length > 0 && (
              <div className="flex flex-wrap gap-2">
                {formData.assignedStudents.map((student) => (
                  <span
                    key={student}
                    className="inline-flex items-center px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm"
                  >
                    {student}
                    <button
                      type="button"
                      onClick={() => removeStudent(student)}
                      className="ml-2 text-blue-600 hover:text-blue-800"
                    >
                      <X className="w-4 h-4" />
                    </button>
                  </span>
                ))}
              </div>
            )}
          </div>

          {/* Questions */}
          <div>
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-semibold text-gray-900">Questions</h3>
              <button
                type="button"
                onClick={addQuestion}
                className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-colors flex items-center"
              >
                <Plus className="w-4 h-4 mr-2" />
                Add Question
              </button>
            </div>

            <div className="space-y-6">
              {questions.map((question, qIndex) => (
                <div key={qIndex} className="border border-gray-200 rounded-lg p-4">
                  <div className="flex justify-between items-start mb-4">
                    <h4 className="text-md font-medium text-gray-900">Question {qIndex + 1}</h4>
                    {questions.length > 1 && (
                      <button
                        type="button"
                        onClick={() => removeQuestion(qIndex)}
                        className="text-red-600 hover:text-red-800"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    )}
                  </div>

                  <div className="mb-4">
                    <textarea
                      value={question.questionText}
                      onChange={(e) => updateQuestion(qIndex, 'questionText', e.target.value)}
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      rows={2}
                      placeholder="Enter your question"
                      required
                    />
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    {question.options.map((option, oIndex) => (
                      <div key={oIndex} className="flex items-center space-x-2">
                        <input
                          type="radio"
                          name={`correct-${qIndex}`}
                          checked={question.correctAnswer === oIndex}
                          onChange={() => updateQuestion(qIndex, 'correctAnswer', oIndex)}
                          className="text-blue-600"
                        />
                        <input
                          type="text"
                          value={option}
                          onChange={(e) => updateOption(qIndex, oIndex, e.target.value)}
                          className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                          placeholder={`Option ${String.fromCharCode(65 + oIndex)}`}
                          required
                        />
                      </div>
                    ))}
                  </div>
                  
                  <p className="text-sm text-gray-600">
                    Select the correct answer by clicking the radio button next to it.
                  </p>
                </div>
              ))}
            </div>
          </div>

          {/* Submit Buttons */}
          <div className="flex justify-end space-x-4 pt-6 border-t">
            <button
              type="button"
              onClick={onClose}
              className="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Create Assessment
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default CreateAssessmentModal;