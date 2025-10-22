import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../domain/quiz.dart';

class QuizRepository {
  final String filePath;

  QuizRepository(this.filePath);

  Quiz readQuiz() {
    final file = File(filePath);
    final content = file.readAsStringSync();
    final data = jsonDecode(content);

    // Map JSON to domain objects
    var questionsJson = data['questions'] as List;
    var questions = questionsJson.map((q) {
      return Question(
        title: q['title'],
        choices: List<String>.from(q['choices']),
        goodChoice: q['goodChoice'],
        point: q['points'],
      );
    }).toList();

    return Quiz(questions: questions);
  }

  Quiz readQuizWithIds() {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }
    final content = file.readAsStringSync();
    final data = jsonDecode(content);

    var questions = (data['questions'] as List).map((q) {
      return Question(
        id: q['id'] ?? const Uuid().v4(),
        title: q['title'],
        choices: List<String>.from(q['choices']),
        goodChoice: q['goodChoice'],
        point: q['points'],
      );
    }).toList();

    var answers = (data['answers'] as List?)?.map((a) {
      return Answer(
        id: a['id'] ?? const Uuid().v4(),
        questionId: a['questionId'],
        answerChoice: a['answerChoice'],
      );
    }).toList() ?? [];

    return Quiz(
      id: data['id'] ?? const Uuid().v4(),
      questions: questions,
      answers: answers,
    );
  }

  void saveQuiz(Quiz quiz) {
    final file = File(filePath);
    final json = {
      'id': quiz.id,
      'questions': quiz.questions.map((q) => {
            'id': q.id,
            'title': q.title,
            'choices': q.choices,
            'goodChoice': q.goodChoice,
            'points': q.point,
          }).toList(),
      'answers': quiz.answers.map((a) => {
            'id': a.id,
            'questionId': a.questionId,
            'answerChoice': a.answerChoice,
          }).toList(),
    };
    file.writeAsStringSync(jsonEncode(json));
  }
}