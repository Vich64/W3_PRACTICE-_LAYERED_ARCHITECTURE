import 'dart:io';
import 'data/quiz_file_provider.dart';
import 'ui/quiz_console.dart';

void main() {

  final scriptPath = Platform.script.toFilePath();
  final scriptDir = Directory(scriptPath).parent;
  final jsonPath = scriptDir.path + Platform.pathSeparator + 'data' + Platform.pathSeparator + 'quiz.json';
  QuizRepository repo = QuizRepository(jsonPath);

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
    print('Quiz saved to quiz.json');
  } catch (e) {
    print('Error loading or running quiz: $e');
    print('Please ensure quiz.json exists and is correctly formatted.');
  }
}
