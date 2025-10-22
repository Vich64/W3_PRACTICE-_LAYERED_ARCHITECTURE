import 'package:uuid/uuid.dart';

class Question{
  final String id;
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int point;

  Question({String? id, required this.title, required this.choices, required this.goodChoice, required this.point}) : id = id ?? const Uuid().v4();
}
class Answer {
  final String id;
  final String questionId;
  final String answerChoice;

  Answer({String? id, required this.questionId, required this.answerChoice}) : id = id ?? const Uuid().v4();

  bool isGood(Question question) {
    return answerChoice == question.goodChoice;
  }

}

class Quiz {
  final String id;
  final List<Question> questions;
  final List<Answer> answers;

  Quiz({String? id, required this.questions, List<Answer>? answers,}) : id = id ?? const Uuid().v4(), answers = answers ?? [];

  // Getters for ID
  Question? getQuestionById(String id) {
    try {
      return questions.firstWhere((q) => q.id == id);
    } catch (e) {
      print('Quesion not found');
    }
    return null;
  }

  Answer? getAnswerById(String id) {
    try {
      return answers.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  void addAnswer(Answer answer) {
    answers.add(answer);
  }

  int getScoreInPercentage() {
    if (answers.isEmpty) return 0;
    int totalScore = 0;
    for (Answer answer in answers) {
      final question = getQuestionById(answer.questionId);
      if (question != null && answer.isGood(question)) {
        totalScore++;
      }
    }
    return ((totalScore / answers.length) * 100).toInt();
  }

  int getScoreInTotal() {
    int totalScore = 0;
    for (Answer answer in answers) {
      final question = getQuestionById(answer.questionId);
      if (question != null && answer.isGood(question)) {
        totalScore += question.point;
      }
    }
    return totalScore;
  }
}