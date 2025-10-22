import 'data/quiz_file_provider.dart';
import 'ui/quiz_console.dart';

void main() {
  // Initialize QuizRepository with JSON file path
  QuizRepository repo = QuizRepository('quiz.json');

  // Load quiz from JSON
  try {
    var quiz = repo.readQuizWithIds();
    print('Loaded quiz from JSON with ID: ${quiz.id}');
    print('Number of questions: ${quiz.questions.length}');
    print('Questions:');
    for (var question in quiz.questions) {
      print('- ${question.title} (ID: ${question.id})');
    }
    print('Number of existing answers: ${quiz.answers.length}');

    // Run the quiz
    QuizConsole console = QuizConsole(quiz: quiz);
    console.startQuiz();

    // Save the quiz state
    repo.saveQuiz(quiz);
    print('Quiz saved to data/quiz.json');
  } catch (e) {
    print('Error loading or running quiz: $e');
    print('Please ensure data/quiz.json exists and is correctly formatted.');
  }
}